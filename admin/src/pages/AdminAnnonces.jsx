import React, { useEffect, useState } from 'react';
import { getAnnonces, createAnnonce, deleteAnnonce, getImageUrl } from '../services/api';
import { styles } from '../css/style';

const AdminAnnonces = () => {
  const [annonces, setAnnonces] = useState([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState({ texte: '', imageFile: null });
  const [uploading, setUploading] = useState(false);

  useEffect(() => {
    fetchAnnonces();
  }, []);

  async function fetchAnnonces() {
    try {
      const data = await getAnnonces();
      setAnnonces(data);
    } catch {
      alert('Erreur chargement annonces');
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id) {
    if (!window.confirm('Confirmer suppression ?')) return;
    try {
      await deleteAnnonce(id);
      setAnnonces(annonces.filter(a => a._id !== id));
    } catch {
      alert('Erreur suppression');
    }
  }

  async function handleSubmit(e) {
    e.preventDefault();
    if (!form.texte || !form.imageFile) {
      alert('Remplir texte et sélectionner image');
      return;
    }
    setUploading(true);

    const data = new FormData();
    data.append('texte', form.texte);
    data.append('image', form.imageFile);

    try {
      await createAnnonce(data);
      alert('Annonce créée !');
      setForm({ texte: '', imageFile: null });
      fetchAnnonces();
    } catch {
      alert('Erreur création annonce');
    } finally {
      setUploading(false);
    }
  }

  if (loading) return <p style={styles.emptyState}>Chargement...</p>;

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Gestion des Annonces</h2>

      <form style={styles.formContainer} onSubmit={handleSubmit}>
        <div style={styles.inputContainer}>
          <div>
            <label style={styles.label}>Texte annonce</label>
            <input
              type="text"
              placeholder="Texte annonce"
              style={styles.input}
              value={form.texte}
              onChange={e => setForm({ ...form, texte: e.target.value })}
            />
          </div>
          <div>
            <label style={styles.label}>Image</label>
            <input
              type="file"
              required
              accept="image/*"
              style={styles.input}
              onChange={e => setForm({ ...form, imageFile: e.target.files[0] })}
            />
          </div>
        </div>

        <div style={styles.buttonContainer}>
          <button type="submit" style={styles.btnPrimary} disabled={uploading}>
            {uploading ? 'Création...' : 'Ajouter'}
          </button>
        </div>
      </form>

      <div style={styles.tableContainer}>
        <table style={styles.table}>
          <thead style={styles.tableHeader}>
            <tr>
              <th style={styles.th}>Image</th>
              <th style={styles.th}>Texte</th>
              <th style={styles.thCenter}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {annonces.length === 0 && (
              <tr>
                <td colSpan={3} style={styles.emptyState}>Aucune annonce disponible</td>
              </tr>
            )}
            {annonces.map(({ _id, image, texte }, i) => (
              <tr key={_id} style={i % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                <td style={styles.td}>
                  <img
                    src={getImageUrl(image)}
                    alt="Annonce"
                    style={{ width: 100, height: 60, objectFit: 'cover', borderRadius: 6 }}
                    onError={e => (e.target.src = 'https://via.placeholder.com/100x60?text=No+Image')}
                  />
                </td>
                <td style={styles.td}>{texte}</td>
                <td style={styles.tdCenter}>
                  <button style={styles.btnDelete} onClick={() => handleDelete(_id)}>
                    Supprimer
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminAnnonces;
