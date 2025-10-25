// =================== IMPORTS ===================
// TOUS les imports DOIVENT être en PREMIER
import { supabase } from '../config/supabaseClient';

// =================== CONFIGURATION ===================
// Configuration de l'URL de base
//const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

// ============================================= 
// =================== USERS API (SUPABASE) =====================

// Récupérer tous les utilisateurs
export async function getUsers() {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  // Reformater pour garder la même structure que MongoDB
  return data.map(user => ({
    _id: user.id,
    name: user.name,
    email: user.email,
    age: user.age,
    createdAt: user.created_at
  }));
}

// Créer un utilisateur
export async function createUser(payload) {
  const { data, error } = await supabase
    .from('users')
    .insert({
      name: payload.name,
      email: payload.email,
      age: payload.age
    })
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  return {
    _id: data.id,
    name: data.name,
    email: data.email,
    age: data.age,
    createdAt: data.created_at
  };
}

// Supprimer un utilisateur
export async function deleteUser(id) {
  const { error } = await supabase
    .from('users')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Utilisateur supprimé' };
}

// Mettre à jour un utilisateur
export async function updateUser(id, payload) {
  const { data, error } = await supabase
    .from('users')
    .update({
      name: payload.name,
      email: payload.email,
      age: payload.age
    })
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  return {
    _id: data.id,
    name: data.name,
    email: data.email,
    age: data.age
  };
}
//=====================================================================================
// =================== AUDIOS API (SUPABASE) =====================

// Récupérer tous les audios avec leurs églises
export async function getAudios() {
  const { data, error } = await supabase
    .from('audios')
    .select(`
      *,
      audios_eglises (
        eglises (
          id,
          nom
        )
      )
    `)
    .eq('is_active', true)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  // Reformater pour garder la même structure que MongoDB
  return data.map(audio => ({
    _id: audio.id,
    titre: audio.titre,
    artiste: audio.artiste,
    album: audio.album,
    genre: audio.genre,
    description: audio.description,
    audioPath: audio.audio_url,
    audioMimeType: 'audio/mpeg',
    imagePath: audio.image_url,
    duration: audio.duration,
    uploadedAt: audio.created_at,
    playCount: audio.play_count,
    isActive: audio.is_active,
    eglises: audio.audios_eglises.map(ae => ({
      _id: ae.eglises.id,
      nom: ae.eglises.nom
    }))
  }));
}

// Upload un audio
export async function uploadAudio(formData) {
  const titre = formData.get('titre');
  const artiste = formData.get('artiste');
  const album = formData.get('album');
  const genre = formData.get('genre');
  const description = formData.get('description');
  const audioFile = formData.get('audio');
  const imageFile = formData.get('image');
  const eglisesIds = formData.getAll('eglises');
  
  if (!audioFile || !imageFile) throw new Error('Fichiers audio et image requis');
  
  // 1. Upload audio vers Supabase Storage
  const audioFileName = `${Date.now()}-${audioFile.name}`;
  const { error: audioError } = await supabase.storage
    .from('audios')
    .upload(audioFileName, audioFile);
  
  if (audioError) throw new Error(audioError.message);
  
  // 2. Upload image vers Supabase Storage
  const imageFileName = `${Date.now()}-${imageFile.name}`;
  const { error: imageError } = await supabase.storage
    .from('images')
    .upload(`audios/${imageFileName}`, imageFile);
  
  if (imageError) throw new Error(imageError.message);
  
  // 3. Obtenir les URLs publiques
  const { data: audioUrlData } = supabase.storage
    .from('audios')
    .getPublicUrl(audioFileName);
  
  const { data: imageUrlData } = supabase.storage
    .from('images')
    .getPublicUrl(`audios/${imageFileName}`);
  
  // 4. Insérer dans la table audios
  const { data: audio, error: dbError } = await supabase
    .from('audios')
    .insert({
      titre: titre,
      artiste: artiste,
      album: album || '',
      genre: genre || '',
      description: description || '',
      audio_url: audioUrlData.publicUrl,
      image_url: imageUrlData.publicUrl,
      duration: 0
    })
    .select()
    .single();
  
  if (dbError) throw new Error(dbError.message);
  
  // 5. Associer les églises (table de liaison)
  if (eglisesIds && eglisesIds.length > 0) {
    const links = eglisesIds.map(egliseId => ({
      audio_id: audio.id,
      eglise_id: egliseId
    }));
    
    const { error: linkError } = await supabase
      .from('audios_eglises')
      .insert(links);
    
    if (linkError) throw new Error(linkError.message);
  }
  
  return {
    _id: audio.id,
    titre: audio.titre,
    artiste: audio.artiste,
    audioPath: audio.audio_url,
    imagePath: audio.image_url
  };
}

// Supprimer un audio
export async function deleteAudio(id) {
  // 1. Récupérer l'audio pour avoir les URLs
  const { data: audio, error: fetchError } = await supabase
    .from('audios')
    .select('audio_url, image_url')
    .eq('id', id)
    .single();
  
  if (fetchError) throw new Error(fetchError.message);
  
  // 2. Supprimer les fichiers du Storage
  if (audio.audio_url) {
    const audioFileName = audio.audio_url.split('/').pop();
    await supabase.storage.from('audios').remove([audioFileName]);
  }
  
  if (audio.image_url) {
    const imageFileName = audio.image_url.split('/').pop();
    await supabase.storage.from('images').remove([`audios/${imageFileName}`]);
  }
  
  // 3. Supprimer de la base de données (CASCADE supprime aussi audios_eglises)
  const { error } = await supabase
    .from('audios')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Audio supprimé' };
}

// Mettre à jour un audio (si nécessaire)
export async function updateAudio(id, payload) {
  const { data, error } = await supabase
    .from('audios')
    .update(payload)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  return data;
}

// =================== CATEGORIES API =====================
// =================== CATEGORIES API (SUPABASE) =====================


// Récupérer toutes les catégories depuis Supabase
export async function getCategories() {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .eq('is_active', true)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  // Reformater pour garder la même structure que MongoDB
  return data.map(cat => ({
    _id: cat.id,              // Supabase utilise 'id', on renomme en '_id'
    nom: cat.nom,
    description: cat.description,
    imagePath: cat.image_url, // Supabase utilise 'image_url'
    createdAt: cat.created_at,
    isActive: cat.is_active
  }));
}

// Créer une catégorie dans Supabase
export async function createCategory(formData) {
  // 1. Extraire les données du FormData
  const nom = formData.get('nom');
  const description = formData.get('description');
  const imageFile = formData.get('image');
  
  if (!imageFile) throw new Error('Image requise');
  
  // 2. Upload image vers Supabase Storage
  const imageFileName = `${Date.now()}-${imageFile.name}`;
  const { error: uploadError } = await supabase.storage
    .from('images')
    .upload(`categories/${imageFileName}`, imageFile);
  
  if (uploadError) throw new Error(uploadError.message);
  
  // 3. Obtenir l'URL publique
  const { data: urlData } = supabase.storage
    .from('images')
    .getPublicUrl(`categories/${imageFileName}`);
  
  // 4. Insérer dans la table categories
  const { data, error } = await supabase
    .from('categories')
    .insert({
      nom: nom,
      description: description || '',
      image_url: urlData.publicUrl
    })
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  // Reformater pour garder la même structure
  return {
    _id: data.id,
    nom: data.nom,
    description: data.description,
    imagePath: data.image_url,
    createdAt: data.created_at
  };
}

// Supprimer une catégorie de Supabase
export async function deleteCategory(id) {
  // 1. Récupérer la catégorie pour avoir l'URL de l'image
  const { data: category, error: fetchError } = await supabase
    .from('categories')
    .select('image_url')
    .eq('id', id)
    .single();
  
  if (fetchError) throw new Error(fetchError.message);
  
  // 2. Supprimer l'image du Storage
  if (category.image_url) {
    const imageFileName = category.image_url.split('/').pop();
    await supabase.storage
      .from('images')
      .remove([`categories/${imageFileName}`]);
  }
  
  // 3. Supprimer de la base de données
  const { error } = await supabase
    .from('categories')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Catégorie supprimée' };
}

// =================== LIVRES API =====================
// =================== LIVRES API (SUPABASE) =====================

// Récupérer tous les livres avec leurs catégories
export async function getLivres() {
  const { data, error } = await supabase
    .from('livres')
    .select(`
      *,
      livres_categories (
        categories (
          id,
          nom
        )
      )
    `)
    .eq('is_active', true)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  // Reformater pour garder la même structure que MongoDB
  return data.map(livre => ({
    _id: livre.id,
    titre: livre.titre,
    auteur: livre.auteur,
    description: livre.description,
    pdfPath: livre.pdf_url,
    imagePath: livre.image_url,
    downloadCount: livre.download_count,
    uploadedAt: livre.created_at,
    isActive: livre.is_active,
    categories: livre.livres_categories.map(lc => ({
      _id: lc.categories.id,
      nom: lc.categories.nom
    }))
  }));
}

// Upload un livre
export async function uploadLivre(formData) {
  const titre = formData.get('titre');
  const auteur = formData.get('auteur');
  const description = formData.get('description');
  const pdfFile = formData.get('pdf');
  const imageFile = formData.get('image');
  const categoriesIds = formData.getAll('categories');
  
  if (!pdfFile || !imageFile) throw new Error('Fichiers PDF et image requis');
  
  // 1. Upload PDF vers Supabase Storage
  const pdfFileName = `${Date.now()}-${pdfFile.name}`;
  const { error: pdfError } = await supabase.storage
    .from('livres')
    .upload(pdfFileName, pdfFile);
  
  if (pdfError) throw new Error(pdfError.message);
  
  // 2. Upload image vers Supabase Storage
  const imageFileName = `${Date.now()}-${imageFile.name}`;
  const { error: imageError } = await supabase.storage
    .from('images')
    .upload(`livres/${imageFileName}`, imageFile);
  
  if (imageError) throw new Error(imageError.message);
  
  // 3. Obtenir les URLs publiques
  const { data: pdfUrlData } = supabase.storage
    .from('livres')
    .getPublicUrl(pdfFileName);
  
  const { data: imageUrlData } = supabase.storage
    .from('images')
    .getPublicUrl(`livres/${imageFileName}`);
  
  // 4. Insérer dans la table livres
  const { data: livre, error: dbError } = await supabase
    .from('livres')
    .insert({
      titre: titre,
      auteur: auteur,
      description: description || '',
      pdf_url: pdfUrlData.publicUrl,
      image_url: imageUrlData.publicUrl
    })
    .select()
    .single();
  
  if (dbError) throw new Error(dbError.message);
  
  // 5. Associer les catégories (table de liaison)
  if (categoriesIds && categoriesIds.length > 0) {
    const links = categoriesIds.map(categoryId => ({
      livre_id: livre.id,
      category_id: categoryId
    }));
    
    const { error: linkError } = await supabase
      .from('livres_categories')
      .insert(links);
    
    if (linkError) throw new Error(linkError.message);
  }
  
  return {
    _id: livre.id,
    titre: livre.titre,
    auteur: livre.auteur,
    pdfPath: livre.pdf_url,
    imagePath: livre.image_url
  };
}

// Supprimer un livre
export async function deleteLivre(id) {
  // 1. Récupérer le livre pour avoir les URLs
  const { data: livre, error: fetchError } = await supabase
    .from('livres')
    .select('pdf_url, image_url')
    .eq('id', id)
    .single();
  
  if (fetchError) throw new Error(fetchError.message);
  
  // 2. Supprimer les fichiers du Storage
  if (livre.pdf_url) {
    const pdfFileName = livre.pdf_url.split('/').pop();
    await supabase.storage.from('livres').remove([pdfFileName]);
  }
  
  if (livre.image_url) {
    const imageFileName = livre.image_url.split('/').pop();
    await supabase.storage.from('images').remove([`livres/${imageFileName}`]);
  }
  
  // 3. Supprimer de la base de données (CASCADE supprime aussi livres_categories)
  const { error } = await supabase
    .from('livres')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Livre supprimé' };
}

// Incrémenter le compteur de téléchargement
export async function incrementDownload(id) {
  const { data, error } = await supabase
    .from('livres')
    .update({ download_count: supabase.sql`download_count + 1` })
    .eq('id', id)
    .select('download_count')
    .single();
  
  if (error) throw new Error(error.message);
  
  return { downloadCount: data.download_count };
}

//===========================================================
// Récupérer toutes les annonces
// =================== ANNONCES API (SUPABASE) =====================

// Récupérer toutes les annonces
export async function getAnnonces() {
  const { data, error } = await supabase
    .from('annonces')
    .select('*')
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  return data.map(annonce => ({
    _id: annonce.id,
    texte: annonce.texte,
    image: annonce.image_url,
    createdAt: annonce.created_at
  }));
}

// Créer une annonce
export async function createAnnonce(formData) {
  const texte = formData.get('texte');
  const imageFile = formData.get('image');
  
  if (!imageFile) throw new Error('Image requise');
  
  // Upload image vers Supabase Storage
  const imageFileName = `${Date.now()}-${imageFile.name}`;
  const { error: uploadError } = await supabase.storage
    .from('images')
    .upload(`annonces/${imageFileName}`, imageFile);
  
  if (uploadError) throw new Error(uploadError.message);
  
  // Obtenir l'URL publique
  const { data: urlData } = supabase.storage
    .from('images')
    .getPublicUrl(`annonces/${imageFileName}`);
  
  // Insérer dans la table
  const { data, error } = await supabase
    .from('annonces')
    .insert({
      texte: texte,
      image_url: urlData.publicUrl
    })
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  return {
    _id: data.id,
    texte: data.texte,
    image: data.image_url,
    createdAt: data.created_at
  };
}

// Supprimer une annonce
export async function deleteAnnonce(id) {
  // Récupérer l'annonce pour avoir l'URL de l'image
  const { data: annonce, error: fetchError } = await supabase
    .from('annonces')
    .select('image_url')
    .eq('id', id)
    .single();
  
  if (fetchError) throw new Error(fetchError.message);
  
  // Supprimer l'image du Storage
  if (annonce.image_url) {
    const imageFileName = annonce.image_url.split('/').pop();
    await supabase.storage
      .from('images')
      .remove([`annonces/${imageFileName}`]);
  }
  
  // Supprimer de la base de données
  const { error } = await supabase
    .from('annonces')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Annonce supprimée' };
}
//=============== les   Api  Les eglise ==========
// =================== ÉGLISES API (SUPABASE) =====================

// Récupérer toutes les églises
export async function getEglises() {
  const { data, error } = await supabase
    .from('eglises')
    .select('*')
    .eq('is_active', true)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  
  return data.map(eglise => ({
    _id: eglise.id,
    nom: eglise.nom,
    imagePath: eglise.image_url,
    createdAt: eglise.created_at,
    isActive: eglise.is_active
  }));
}

// Créer une église
export async function createEglise(formData) {
  const nom = formData.get('nom');
  const imageFile = formData.get('image');
  
  if (!imageFile) throw new Error('Image requise');
  
  // Upload image vers Supabase Storage
  const imageFileName = `${Date.now()}-${imageFile.name}`;
  const { error: uploadError } = await supabase.storage
    .from('images')
    .upload(`eglises/${imageFileName}`, imageFile);
  
  if (uploadError) throw new Error(uploadError.message);
  
  // Obtenir l'URL publique
  const { data: urlData } = supabase.storage
    .from('images')
    .getPublicUrl(`eglises/${imageFileName}`);
  
  // Insérer dans la table
  const { data, error } = await supabase
    .from('eglises')
    .insert({
      nom: nom,
      image_url: urlData.publicUrl
    })
    .select()
    .single();
  
  if (error) throw new Error(error.message);
  
  return {
    _id: data.id,
    nom: data.nom,
    imagePath: data.image_url,
    createdAt: data.created_at
  };
}

// Supprimer une église
export async function deleteEglise(id) {
  // Récupérer l'église pour avoir l'URL de l'image
  const { data: eglise, error: fetchError } = await supabase
    .from('eglises')
    .select('image_url')
    .eq('id', id)
    .single();
  
  if (fetchError) throw new Error(fetchError.message);
  
  // Supprimer l'image du Storage
  if (eglise.image_url) {
    const imageFileName = eglise.image_url.split('/').pop();
    await supabase.storage
      .from('images')
      .remove([`eglises/${imageFileName}`]);
  }
  
  // Supprimer de la base de données
  const { error } = await supabase
    .from('eglises')
    .delete()
    .eq('id', id);
  
  if (error) throw new Error(error.message);
  
  return { message: 'Église supprimée' };
}
//====================  
