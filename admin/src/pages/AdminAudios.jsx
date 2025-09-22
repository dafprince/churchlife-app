import React, { useState, useEffect } from 'react';
import { getAudios, getEglises, updateAudio, deleteAudio } from '../services/api';
import { styles } from '../css/style';

const AdminAudios = () => {
  const [audios, setAudios] = useState([]);
  const [eglises, setEglises] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingAudio, setEditingAudio] = useState(null);
  const [form, setForm] = useState({ titre: '', eglises: [] });
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    async function fetchData() {
      try {
        const audioData = await getAudios();
        const eglisesData = await getEglises();
        setAudios(audioData);
        setEglises(eglisesData);
      } catch (e) {
        alert('Erreur chargement données');
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  function openEdit(audio) {
    setEditingAudio(audio);
    setForm({
      titre: audio.titre,
      eglises: audio.eglises ? audio.eglises.map(e => e._id) : []
    });
  }

  function toggleEglise(id) {
    setForm(prev => ({
      ...prev,
      eglises: prev.eglises.includes(id)
        ? prev.eglises.filter(e => e !== id)
        : [...prev.eglises, id]
    }));
  }

  async function handleSave() {
    setSaving(true);
    try {
      await updateAudio(editingAudio._id, {
        titre: form.titre,
        eglises: form.eglises
      });
      alert('Audio mis à jour');
      // Recharge la liste après maj
      const updated = await getAudios();
      setAudios(updated);
      setEditingAudio(null);
    } catch {
      alert('Erreur sauvegarde');
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <div style={styles.emptyState}>Chargement...</div>;

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Gestion des Audios</h2>

      {editingAudio ? (
        <div>
          <h3>Modifier : {editingAudio.titre}</h3>
          <label>Titre</label>
          <input
            type="text"
            value={form.titre}
            onChange={e => setForm({ ...form, titre: e.target.value })}
          />

          <fieldset>
            <legend>Sélectionnez les Églises</legend>
            {eglises.map(e => (
              <label key={e._id}>
                <input
                  type="checkbox"
                  checked={form.eglises.includes(e._id)}
                  onChange={() => toggleEglise(e._id)}
                />
                {e.nom}
              </label>
            ))}
          </fieldset>

          <button onClick={handleSave} disabled={saving}>
            {saving ? 'Sauvegarde...' : 'Sauvegarder'}
          </button>
          <button onClick={() => setEditingAudio(null)}>Annuler</button>
        </div>
      ) : (
        <ul>
          {audios.map(a => (
            <li key={a._id}>
              {a.titre} - Églises : {a.eglises?.map(e => e.nom).join(', ') || 'Aucune'}
              <button onClick={() => openEdit(a)}>Modifier</button>
              <button onClick={async () => {
                if(window.confirm('Supprimer cet audio ?')) {
                  await deleteAudio(a._id);
                  setAudios(audios.filter(x => x._id !== a._id));
                }
              }}>Supprimer</button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};


export default AdminAudios;
