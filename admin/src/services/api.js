// src/services/api.js
// dans ../services/api. C’est elle qui fait l’appel au backend.


// ============================================= 
export async function getUsers() {
  const res = await fetch('/api/users'); // proxy -> http://localhost:5000/api/users
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}
// ============================================= 
export async function createUser(payload) {
  const res = await fetch('/api/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Erreur lors de la création');
  return res.json();
}
//============================================================ 
export async function deleteUser(id) {
  const res = await fetch(`/api/users/${id}`, { method: 'DELETE' });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json(); // { message, user }
}
//================== 👉 NOUVEAU : mise à jour =====================
export async function updateUser(id, payload) {
  const res = await fetch(`/api/users/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  if (!res.ok) throw new Error('Erreur réseau (updateUser)');
  return res.json();
}
//===========
// Ajouter à la fin de votre api.js
export async function getAudios() {
  const res = await fetch('/api/audios');
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}
//====
// Fonction pour supprimer un audio
export async function deleteAudio(id) {
  const res = await fetch(`/api/audios/${id}`, { 
    method: 'DELETE' 
  });
  if (!res.ok) throw new Error('Suppression audio échouée');
  return res.json();
}
//===
// Fonction pour uploader un audio
export async function uploadAudio(formData) {
  const res = await fetch('/api/audios/upload', {
    method: 'POST',
    body: formData  // Pas de headers, FormData gère tout
  });
  if (!res.ok) throw new Error('Erreur lors de l\'upload');
  return res.json();
}

// =================== CATEGORIES API =====================

// Récupérer toutes les catégories
export async function getCategories() {
  const res = await fetch('/api/categories');
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

// Créer une catégorie
export async function createCategory(formData) {
  const res = await fetch('/api/categories/create', {
    method: 'POST',
    body: formData  // FormData car on envoie une image
  });
  if (!res.ok) throw new Error('Erreur lors de la création');
  return res.json();
}

// Supprimer une catégorie
export async function deleteCategory(id) {
  const res = await fetch(`/api/categories/${id}`, {
    method: 'DELETE'
  });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json();
}
// =================== LIVRES API =====================

// Récupérer tous les livres
export async function getLivres() {
  const res = await fetch('/api/livres');
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

// Upload un livre
export async function uploadLivre(formData) {
  const res = await fetch('/api/livres/upload', {
    method: 'POST',
    body: formData
  });
  if (!res.ok) throw new Error('Erreur lors de l\'upload');
  return res.json();
}

// Supprimer un livre
export async function deleteLivre(id) {
  const res = await fetch(`/api/livres/${id}`, {
    method: 'DELETE'
  });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json();
}

// Incrémenter le compteur de téléchargement
export async function incrementDownload(id) {
  const res = await fetch(`/api/livres/${id}/download`, {
    method: 'PUT'
  });
  if (!res.ok) throw new Error('Erreur');
  return res.json();
}
