import React, { useState, useEffect } from 'react';
import { getEglises, createEglise, deleteEglise, getImageUrl } from '../services/api';
import { styles } from '../css/style';

const EglisesPage = () => {
  const [eglises, setEglises] = useState([]);
  const [loading, setLoading] = useState(true);
  const [formData, setFormData] = useState({ nom: '' });
  const [imageFile, setImageFile] = useState(null);
  const [uploading, setUploading] = useState(false);

  useEffect(() => {
    fetchEglises();
  }, []);

  async function fetchEglises() {
    try {
      const data = await getEglises();
      setEglises(data);
    } catch {
      alert('Erreur chargement églises');
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id, nom) {
    if (!window.confirm(`Supprimer l'église "${nom}" ?`)) return;
    try {
      await deleteEglise(id);
      setEglises(eglises.filter(e => e._id !== id));
    } catch {
      alert('Erreur suppression église');
    }
  }

  async function handleSubmit(e) {
    e.preventDefault();
    if (!formData.nom || !imageFile) {
      alert('Veuillez saisir un nom et choisir une image');
      return;
    }
    setUploading(true);

    const data = new FormData();
    data.append('nom', formData.nom);
    data.append('image', imageFile);

    try {
      await createEglise(data);
      alert('Église créée');
      setFormData({ nom: '' });
      setImageFile(null);
      fetchEglises();
    } catch {
      alert('Erreur création église');
    } finally {
      setUploading(false);
    }
  }

  if (loading) return <p style={styles.emptyState}>Chargement...</p>;

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Gestion des Églises</h2>

      <form style={styles.formContainer} onSubmit={handleSubmit}>
        <div style={styles.inputContainer}>
          <div>
            <label style={styles.label}>Nom Église</label>
            <input
              type="text"
              value={formData.nom}
              onChange={e => setFormData({ ...formData, nom: e.target.value })}
              style={styles.input}
              placeholder="Nom de l'église"
              required
            />
          </div>
          <div>
            <label style={styles.label}>Image</label>
            <input
              type="file"
              accept="image/*"
              onChange={e => setImageFile(e.target.files[0])}
              style={styles.input}
              required
            />
          </div>
        </div>
        <div style={styles.buttonContainer}>
          <button type="submit" style={styles.btnPrimary} disabled={uploading}>
            {uploading ? 'Création...' : 'Créer'}
          </button>
        </div>
      </form>

      <div style={styles.tableContainer}>
        <table style={styles.table}>
          <thead style={styles.tableHeader}>
            <tr>
              <th style={styles.th}>Image</th>
              <th style={styles.th}>Nom</th>
              <th style={styles.th}>Date création</th>
              <th style={styles.thCenter}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {eglises.map((eglise, idx) => (
              <tr key={eglise._id} style={idx % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                <td style={styles.td}>
                  <img
                    src={getImageUrl(eglise.imagePath)}
                    alt={eglise.nom}
                    style={{ width: 60, height: 60, borderRadius: 8, objectFit: 'cover' }}
                    onError={e => (e.target.src = 'https://via.placeholder.com/60?text=No+Image')}
                  />
                </td>
                <td style={styles.td}>{eglise.nom}</td>
                <td style={styles.td}>{new Date(eglise.createdAt).toLocaleDateString('fr-FR')}</td>
                <td style={styles.tdCenter}>
                  <button style={styles.btnDelete} onClick={() => handleDelete(eglise._id, eglise.nom)}>
                    Supprimer
                  </button>
                </td>
              </tr>
            ))}
            {eglises.length === 0 && (
              <tr>
                <td colSpan={4} style={styles.emptyState}>
                  Aucune église disponible
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default EglisesPage;
