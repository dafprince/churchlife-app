import React, { useState, useEffect } from "react";
import { styles } from "../css/style";
import { getCategories, createCategory, deleteCategory } from "../services/api";

const CategorieLivresPage = () => {
  // États pour les catégories
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  
  // États pour le formulaire
  const [formData, setFormData] = useState({
    nom: '',
    description: ''
  });
  const [imageFile, setImageFile] = useState(null);
  const [uploading, setUploading] = useState(false);

  // Charger les catégories au montage
  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const data = await getCategories();
      setCategories(data);
    } catch (error) {
      console.error('Erreur:', error);
    } finally {
      setLoading(false);
    }
  };

  // Supprimer une catégorie
  const handleDelete = async (id, nom) => {
    if (!window.confirm(`Supprimer la catégorie "${nom}" ?`)) return;
    
    try {
      await deleteCategory(id);
      setCategories(categories.filter(cat => cat._id !== id));
    } catch (error) {
      alert('Erreur lors de la suppression');
    }
  };

  // Gérer la soumission du formulaire
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!imageFile) {
      alert('Veuillez sélectionner une image');
      return;
    }

    setUploading(true);
    
    const data = new FormData();
    data.append('nom', formData.nom);
    data.append('description', formData.description);
    data.append('image', imageFile);

    try {
      await createCategory(data);
      alert('Catégorie créée avec succès !');
      
      // Reset form
      setFormData({ nom: '', description: '' });
      setImageFile(null);
      
      // Recharger la liste
      fetchCategories();
    } catch (error) {
      alert('Erreur lors de la création');
    } finally {
      setUploading(false);
    }
  };

  if (loading) return <div style={{ padding: '20px' }}>Chargement des catégories...</div>;

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Catégories de Livres</h2>

      {/* Formulaire d'ajout */}
      <div style={styles.formContainer}>
        <h3 style={styles.formTitle}>Ajouter une catégorie</h3>
        <form onSubmit={handleSubmit}>
          <div style={styles.inputContainer}>
            <div>
              <label style={styles.label}>Nom *</label>
              <input
                type="text"
                required
                style={styles.input}
                value={formData.nom}
                onChange={(e) => setFormData({...formData, nom: e.target.value})}
                placeholder="Ex: Science Fiction"
              />
            </div>
            
            <div>
              <label style={styles.label}>Description</label>
              <input
                type="text"
                style={styles.input}
                value={formData.description}
                onChange={(e) => setFormData({...formData, description: e.target.value})}
                placeholder="Description de la catégorie"
              />
            </div>
            
            <div>
              <label style={styles.label}>Image *</label>
              <input
                type="file"
                required
                accept="image/*"
                onChange={(e) => setImageFile(e.target.files[0])}
              />
            </div>
          </div>
          
          <div style={styles.buttonContainer}>
            <button 
              type="submit" 
              style={styles.btnPrimary}
              disabled={uploading}
            >
              {uploading ? 'Création...' : 'Créer la catégorie'}
            </button>
          </div>
        </form>
      </div>

      {/* Tableau des catégories */}
      <div style={styles.tableContainer}>
        <table style={styles.table}>
          <thead style={styles.tableHeader}>
            <tr>
              <th style={styles.th}>Image</th>
              <th style={styles.th}>Nom</th>
              <th style={styles.th}>Description</th>
              <th style={styles.th}>Date de création</th>
              <th style={styles.thCenter}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {categories.map((cat, index) => (
              <tr
                key={cat._id}
                style={index % 2 === 0 ? styles.rowEven : styles.rowOdd}
              >
                <td style={styles.td}>
                  <img 
                    src={`http://localhost:5000/${cat.imagePath}`}
                    alt={cat.nom} 
                    style={{ 
                      width: '60px', 
                      height: '60px', 
                      borderRadius: '8px', 
                      objectFit: 'cover' 
                    }}
                    onError={(e) => {
                      e.target.src = 'https://via.placeholder.com/60?text=No+Image';
                    }}
                  />
                </td>
                <td style={styles.td}><strong>{cat.nom}</strong></td>
                <td style={styles.td}>{cat.description || 'Aucune description'}</td>
                <td style={styles.td}>
                  {new Date(cat.createdAt).toLocaleDateString('fr-FR')}
                </td>
                <td style={styles.tdCenter}>
                  <button
                    style={styles.btnDelete}
                    onClick={() => handleDelete(cat._id, cat.nom)}
                  >
                    Supprimer
                  </button>
                </td>
              </tr>
            ))}
            {categories.length === 0 && (
              <tr>
                <td colSpan="5" style={styles.emptyState}>
                  Aucune catégorie disponible
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Stats */}
      <div style={styles.stats}>
        Total: {categories.length} catégorie{categories.length !== 1 ? 's' : ''}
      </div>
    </div>
  );
};

export default CategorieLivresPage;