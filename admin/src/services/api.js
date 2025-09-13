// Configuration de l'URL de base
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

// ============================================= 
export async function getUsers() {
  const res = await fetch(`${API_BASE_URL}/users`);
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

// ============================================= 
export async function createUser(payload) {
  const res = await fetch(`${API_BASE_URL}/users`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error('Erreur lors de la création');
  return res.json();
}

//============================================================ 
export async function deleteUser(id) {
  const res = await fetch(`${API_BASE_URL}/users/${id}`, { method: 'DELETE' });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json();
}

//================== 👉 NOUVEAU : mise à jour =====================
export async function updateUser(id, payload) {
  const res = await fetch(`${API_BASE_URL}/users/${id}`, {
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
  const res = await fetch(`${API_BASE_URL}/audios`);
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

//====
// Fonction pour supprimer un audio
export async function deleteAudio(id) {
  const res = await fetch(`${API_BASE_URL}/audios/${id}`, { 
    method: 'DELETE' 
  });
  if (!res.ok) throw new Error('Suppression audio échouée');
  return res.json();
}

//===
// Fonction pour uploader un audio
export async function uploadAudio(formData) {
  const res = await fetch(`${API_BASE_URL}/audios/upload`, {
    method: 'POST',
    body: formData
  });
  if (!res.ok) throw new Error('Erreur lors de l\'upload');
  return res.json();
}

// =================== CATEGORIES API =====================

// Récupérer toutes les catégories
export async function getCategories() {
  const res = await fetch(`${API_BASE_URL}/categories`);
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

// Créer une catégorie
export async function createCategory(formData) {
  const res = await fetch(`${API_BASE_URL}/categories/create`, {
    method: 'POST',
    body: formData
  });
  if (!res.ok) throw new Error('Erreur lors de la création');
  return res.json();
}

// Supprimer une catégorie
export async function deleteCategory(id) {
  const res = await fetch(`${API_BASE_URL}/categories/${id}`, {
    method: 'DELETE'
  });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json();
}

// =================== LIVRES API =====================

// Récupérer tous les livres
export async function getLivres() {
  const res = await fetch(`${API_BASE_URL}/livres`);
  if (!res.ok) throw new Error('Erreur réseau');
  return res.json();
}

// Upload un livre
export async function uploadLivre(formData) {
  const res = await fetch(`${API_BASE_URL}/livres/upload`, {
    method: 'POST',
    body: formData
  });
  if (!res.ok) throw new Error('Erreur lors de l\'upload');
  return res.json();
}

// Supprimer un livre
export async function deleteLivre(id) {
  const res = await fetch(`${API_BASE_URL}/livres/${id}`, {
    method: 'DELETE'
  });
  if (!res.ok) throw new Error('Suppression échouée');
  return res.json();
}

// Incrémenter le compteur de téléchargement
export async function incrementDownload(id) {
  const res = await fetch(`${API_BASE_URL}/livres/${id}/download`, {
    method: 'PUT'
  });
  if (!res.ok) throw new Error('Erreur');
  return res.json();
}