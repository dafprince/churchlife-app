import React, { useEffect, useState } from 'react';
import { getUsers, createUser , deleteUser , updateUser  } from '../services/api';
import { styles } from '../css/style.js';

export default function AdminUsers() {
  const [formData, setFormData] = useState({ name: '', email: '', age: '' });
  const [users, setUsers] = useState([]);
  const [etat, setEtat] = useState('loading');
  const [error, setError] = useState('');
  const [deletingId, setDeletingId] = useState(null);
// editer user
  const [editingId, setEditingId] = useState(null); // 👉 null = ajout, sinon édition
  const [saving, setSaving] = useState(false);       // pour désactiver le bouton pendant l’envoi
  const [message, setMessage] = useState(null);      // petit feedback visuel (succès/erreur)
  const [messageType, setMessageType] = useState('success');

  // Charger la liste au montage
  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = () => {
    getUsers()
      .then(data => { setUsers(data); setEtat('ok'); })
      .catch(err => { setError(err.message); setEtat('error'); });
  };

  const handleInputChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  // AJOUT utilisateur
  /*
  const handleAddUser = async (e) => {
    e.preventDefault(); // évite le reload
    try {
      // Convertir age en nombre avant envoi
      const newUser = { ...formData, age: parseInt(formData.age, 10) };
      await createUser(newUser);
      setFormData({ name: '', email: '', age: '' }); // reset formulaire
      fetchUsers(); // recharger la liste
    } catch (err) {
      console.error('Erreur ajout utilisateur:', err);
    }
  };
  */
  // Supprimer utilisateur
  const handleDelete = async (id) => {
  const ok = window.confirm('Supprimer cet utilisateur ?');
  if (!ok) return;

  try {
    setDeletingId(id);
    await deleteUser(id);
    // Mise à jour immédiate de la liste côté UI
    setUsers(prev => prev.filter(u => u._id !== id));
  } catch (err) {
    setError(err.message);
    setEtat('error');
  } finally {
    setDeletingId(null);
  }
};
// ==== EDITER USER===================================
 // Commencer une édition : remplir le formulaire et définir l'id en cours
  const startEdit = (user) => {
    setEditingId(user._id);
    setFormData({
      name: user.name || '',
      email: user.email || '',
      age: user.age != null ? String(user.age) : ''
    });
    window.scrollTo({ top: 0, behavior: 'smooth' }); // remonte vers le formulaire
  };
  // Annuler l’édition
  const cancelEdit = () => {
    setEditingId(null);
    setFormData({ name: '', email: '', age: '' });
  };
    // Soumission (ajout OU mise à jour selon editingId)
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      setSaving(true);

      // petites vérifs
      if (!formData.name || !formData.email || formData.age === '') {
        throw new Error('Veuillez remplir nom, email et âge.');
      }

      const payload = {
        name: formData.name.trim(),
        email: formData.email.trim(),
        age: parseInt(formData.age, 10)
      };

      if (Number.isNaN(payload.age)) {
        throw new Error("L'âge doit être un nombre.");
      }

      if (editingId) {
        // 👉 Mise à jour
        await updateUser(editingId, payload);
        setMessage('Utilisateur mis à jour ✅');
        setMessageType('success');
      } else {
        // 👉 Ajout
        await createUser(payload);
        setMessage('Utilisateur ajouté ✅');
        setMessageType('success');
      }

      // reset + reload
      setFormData({ name: '', email: '', age: '' });
      setEditingId(null);
      fetchUsers();
    } catch (err) {
      setMessage(`Erreur: ${err.message}`);
      setMessageType('error');
    } finally {
      setSaving(false);
      setTimeout(() => setMessage(null), 3000);
    }
  };
  //============================================================

  if (etat === 'loading') return <p style={{ padding: 16 }}>Chargement…</p>;
  if (etat === 'error') return <p style={{ padding: 16 }}>Erreur : {error}</p>;

  return (
    <div  style={{ width: '100%', padding: '24px' }}>
      <h1 style={styles.title}>Gestionnaire d'Utilisateurs</h1>

       {/* Message visuel */}
      {message && (
        <div style={{
          padding: 10, marginBottom: 12, borderRadius: 6,
          backgroundColor: messageType === 'success' ? '#d1fae5' : '#fee2e2',
          color: messageType === 'success' ? '#065f46' : '#991b1b'
        }}>
          {message}
        </div>
      )}

      {/* Table des utilisateurs */}
      <div style={styles.tableContainer}>
        <table style={styles.table}>
          <thead style={styles.tableHeader}>
            <tr>
              <th style={styles.th}>ID</th>
              <th style={styles.th}>Nom</th>
              <th style={styles.th}>Email</th>
              <th style={styles.th}>Age</th>
              <th style={styles.thCenter}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user, index) => (
              <tr key={user._id} style={index % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                <td style={styles.td}><strong>{user._id}</strong></td>
                <td style={styles.td}>{user.name}</td>
                <td style={styles.td}>{user.email}</td>
                <td style={styles.td}>{user.age}</td>
                <td style={styles.tdCenter}>
                 <button
                    style={styles.btnEdit}
                    onClick={() => startEdit(user)}
                    onMouseOver={(e) => e.target.style.backgroundColor = '#d97706'}
                    onMouseOut={(e) => e.target.style.backgroundColor = '#eab308'}
                  >
                    Modifier
                  </button>
                  <button style={styles.btnDelete}
                   disabled={deletingId === user._id}
                    onClick={() => handleDelete(user._id)}
                    onMouseOver={(e) => e.target.style.backgroundColor = '#dc2626'}
                    onMouseOut={(e) => e.target.style.backgroundColor = '#ef4444'}
                  >{deletingId === user._id ? 'Suppression…' : 'Supprimer'}</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {users.length === 0 && <div style={styles.emptyState}>Aucun utilisateur trouvé</div>}
      </div>

      {/* Formulaire d'ajout */}
      <div style={styles.formContainer}>
        <h2 style={styles.formTitle}> 
            {editingId ? "Modifier un utilisateur" : "Ajouter un utilisateur"}
            </h2>
        <form onSubmit={handleSubmit}>
          <div style={styles.inputContainer}>
            <div>
              <label style={styles.label}>Nom *</label>
              <input
                type="text"
                name="name"
                style={styles.input}
                placeholder="Entrez le nom"
                value={formData.name}
                onChange={handleInputChange}
              />
            </div>
            <div>
              <label style={styles.label}>Email *</label>
              <input
                type="email"
                name="email"
                style={styles.input}
                placeholder="Entrez le mail"
                value={formData.email}
                onChange={handleInputChange}
              />
            </div>
            <div>
              <label style={styles.label}>Age *</label>
              <input
                type="number"
                name="age"
                style={styles.input}
                placeholder="Entrez votre âge"
                value={formData.age}
                onChange={handleInputChange}
              />
            </div>
          </div>

          <div style={styles.buttonContainer}>
            <button type="submit" style={styles.btnPrimary} disabled={saving}>
               {saving
                ? (editingId ? 'Mise à jour…' : 'Ajout…')
                : (editingId ? 'Mettre à jour' : 'Ajouter')}
                </button>
            {editingId ? (
              <button type="button" style={styles.btnSecondary} onClick={cancelEdit} disabled={saving}>
                Annuler
              </button>
            ) : (
              <button type="button" style={styles.btnSecondary} onClick={() => setFormData({ name: '', email: '', age: '' })} disabled={saving}>
                Vider
              </button>
            )}
          </div>
        </form>
      </div>

      {/* Statistiques */}
      <div style={styles.stats}>
        Total: {users.length} utilisateur{users.length !== 1 ? 's' : ''}
      </div>
    </div>
  );
}
