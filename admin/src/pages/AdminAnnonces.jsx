import React, { useEffect, useState } from 'react';
import { getAnnonces, deleteAnnonce, createAnnonce } from '../services/api';
import { dashboardStyles } from '../css/style'; // ajuste selon ton chemin réel

const AdminAnnonces = () => {
  const [annonces, setAnnonces] = useState([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState({ texte: '', image: '' });
  const [creating, setCreating] = useState(false);

  useEffect(() => {
    fetchAnnonces();
  }, []);

  async function fetchAnnonces() {
    try {
      const data = await getAnnonces();
      setAnnonces(data);
    } catch (err) {
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
    if (!form.image || !form.texte) {
      alert('Remplir texte et URL image');
      return;
    }
    setCreating(true);
    try {
      const newA = await createAnnonce(form);
      setAnnonces([newA, ...annonces]);
      setForm({ texte: '', image: '' });
    } catch {
      alert('Erreur création annonce');
    } finally {
      setCreating(false);
    }
  }

  if (loading) return <p>Chargement...</p>;

  return (
    <div style={dashboardStyles.container}>
      <h2 style={dashboardStyles.title}>Gestion des Annonces</h2>
      <form onSubmit={handleSubmit} style={{ marginBottom: '20px' }}>
        <input
          type="text"
          placeholder="Texte annonce"
          value={form.texte}
          onChange={e => setForm({ ...form, texte: e.target.value })}
          style={{ marginRight: 10, padding: '8px', width: '45%' }}
        />
        <input
          type="text"
          placeholder="URL Image"
          value={form.image}
          onChange={e => setForm({ ...form, image: e.target.value })}
          style={{ marginRight: 10, padding: '8px', width: '45%' }}
        />
        <button type="submit" disabled={creating} style={dashboardStyles.btnPrimary}>
          {creating ? 'Création...' : 'Ajouter'}
        </button>
      </form>

      <table style={dashboardStyles.table}>
        <thead style={dashboardStyles.tableHeader}>
          <tr>
            <th style={dashboardStyles.th}>Image</th>
            <th style={dashboardStyles.th}>Texte</th>
            <th style={dashboardStyles.thCenter}>Actions</th>
          </tr>
        </thead>
        <tbody>
          {annonces.length === 0 && (
            <tr>
              <td colSpan={3} style={dashboardStyles.emptyState}>Aucune annonce disponible</td>
            </tr>
          )}
          {annonces.map(({ _id, image, texte }) => (
            <tr key={_id}>
              <td style={dashboardStyles.td}>
                <img src={image} alt="Annonce" width={100} height={60} style={{ objectFit: 'cover' }} />
              </td>
              <td style={dashboardStyles.td}>{texte}</td>
              <td style={dashboardStyles.tdCenter}>
                <button style={dashboardStyles.btnDelete} onClick={() => handleDelete(_id)}>Supprimer</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default AdminAnnonces;
