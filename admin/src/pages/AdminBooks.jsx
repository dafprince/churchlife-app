import React, { useMemo, useState, useEffect } from 'react';
import { styles, dashboardStyles, bookStyles, modalStyles } from '../css/style';
import { 
  FaList, FaTh, FaSearch, FaPlus, FaTrash, FaDownload, FaFilePdf, FaBook, FaTimes
} from 'react-icons/fa';
import { getLivres, deleteLivre, getCategories, uploadLivre, getImageUrl } from '../services/api';

export default function AdminBooks() {
  // ========== ÉTATS ==========
  const [books, setBooks] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [viewMode, setViewMode] = useState('table');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selected, setSelected] = useState([]);
  
  // États pour le modal d'upload
  const [showUploadModal, setShowUploadModal] = useState(false);

  // ========== CHARGEMENT DES DONNÉES ==========
  useEffect(() => {
    loadData();
  }, []);

 const loadData = async () => {
  try {
    const [livresData, categoriesData] = await Promise.all([
      getLivres(),
      getCategories()
    ]);
    console.log('Livres chargés:', livresData);
    console.log('Catégories dans livre:', livresData[0]?.categories);
    setBooks(livresData);
    setCategories(categoriesData);
  } catch (error) {
    console.error('Erreur chargement:', error);
  } finally {
    setLoading(false);
  }
};

  // ========== CALCUL DES CATÉGORIES POUR LE FILTRE ==========
  const categoryOptions = useMemo(() => {
    const options = ['all'];
    categories.forEach(cat => {
      options.push(cat.nom);
    });
    return options;
  }, [categories]);

  // ========== STATISTIQUES ==========
  const stats = useMemo(() => ({
    total: books.length,
    published: books.filter(b => b.isActive).length,
    drafts: books.filter(b => !b.isActive).length,
    totalViews: 0,
    totalDownloads: books.reduce((a, b) => a + (b.downloadCount || 0), 0),
  }), [books]);

// ========== FILTRAGE DES LIVRES ==========
const filtered = books.filter(b => {
  const matchesSearch =
    (b.titre || '').toLowerCase().includes(search.toLowerCase()) ||
    (b.auteur || '').toLowerCase().includes(search.toLowerCase());
  
  let matchesCat = false;
  if (selectedCategory === 'all') {
    matchesCat = true;
  } else {
    if (b.categories && b.categories.length > 0) {
      if (typeof b.categories[0] === 'object') {
        matchesCat = b.categories.some(cat => cat.nom === selectedCategory);
      } else {
        const selectedCat = categories.find(c => c.nom === selectedCategory);
        matchesCat = selectedCat && b.categories.includes(selectedCat._id);
      }
    }
  }
  
  return matchesSearch && matchesCat;
});

  // ========== SÉLECTION MULTIPLE ==========
  const allVisibleSelected = filtered.length > 0 && filtered.every(b => selected.includes(b._id));

  const toggleSelectAll = (checked) => {
    if (checked) {
      setSelected(Array.from(new Set([...selected, ...filtered.map(b => b._id)])));
    } else {
      setSelected(prev => prev.filter(id => !filtered.some(b => b._id === id)));
    }
  };

  const toggleOne = (id) => {
    setSelected(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  };

  // ========== SUPPRESSION ==========
  const handleDelete = async (id, titre) => {
    if (!window.confirm(`Supprimer le livre "${titre}" ?`)) return;
    
    try {
      await deleteLivre(id);
      setBooks(prev => prev.filter(b => b._id !== id));
      setSelected(prev => prev.filter(x => x !== id));
    } catch (error) {
      alert('Erreur lors de la suppression');
    }
  };

  const handleBulkDelete = async () => {
    if (!window.confirm(`Supprimer ${selected.length} livre(s) ?`)) return;
    
    try {
      for (const id of selected) {
        await deleteLivre(id);
      }
      setBooks(prev => prev.filter(b => !selected.includes(b._id)));
      setSelected([]);
    } catch (error) {
      alert('Erreur lors de la suppression multiple');
    }
  };

  // ========== HELPER : Obtenir les noms des catégories d'un livre ==========
const getCategoryNames = (bookCategories) => {
  if (!bookCategories || bookCategories.length === 0) return 'Non classé';
  
  if (typeof bookCategories[0] === 'object' && bookCategories[0].nom) {
    return bookCategories.map(cat => cat.nom).join(', ');
  }
  
  const names = bookCategories.map(catId => {
    const cat = categories.find(c => c._id === catId);
    return cat ? cat.nom : '';
  }).filter(name => name);
  
  return names.length > 0 ? names.join(', ') : 'Non classé';
};

  // ========== RENDU CONDITIONNEL SI CHARGEMENT ==========
  if (loading) return <div style={{ padding: '20px' }}>Chargement des livres...</div>;

  return (
    <div style={bookStyles.container}>
      {/* ========== HEADER ========== */}
      <div style={bookStyles.header}>
        <div style={bookStyles.headerTitleWrap}>
          <div style={bookStyles.headerTitle}>Bibliothèque PDF</div>
          <div style={bookStyles.headerSub}>{books.length} livre(s) disponible(s)</div>
        </div>
        <button 
          style={bookStyles.addBtn}
          onClick={() => setShowUploadModal(true)}
        >
          <FaPlus /> Ajouter un PDF
        </button>
      </div>

      {/* ========== STATS CARDS ========== */}
      <div style={dashboardStyles.statsGrid}>
        <div style={dashboardStyles.statCard}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ color: '#6b7280', fontSize: 14 }}>Total Livres</div>
              <div style={{ fontSize: 24, fontWeight: 'bold' }}>{stats.total}</div>
            </div>
            <FaBook size={22} color="#3b82f6" />
          </div>
        </div>
        <div style={dashboardStyles.statCard}>
          <div style={{ color: '#6b7280', fontSize: 14 }}>Publiés</div>
          <div style={{ fontSize: 24, fontWeight: 'bold', color: '#059669' }}>{stats.published}</div>
        </div>
        <div style={dashboardStyles.statCard}>
          <div style={{ color: '#6b7280', fontSize: 14 }}>Téléchargements</div>
          <div style={{ fontSize: 24, fontWeight: 'bold', color: '#4f46e5' }}>{stats.totalDownloads}</div>
        </div>
      </div>

      {/* ========== TOOLBAR ========== */}
      <div style={bookStyles.toolbar}>
        <div style={bookStyles.searchWrapper}>
          <FaSearch style={bookStyles.searchIcon} />
          <input
            placeholder="Rechercher par titre, auteur…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={bookStyles.searchInput}
          />
        </div>

        <select
          value={selectedCategory}
          onChange={(e) => setSelectedCategory(e.target.value)}
          style={bookStyles.select}
        >
          {categoryOptions.map(cat => (
            <option key={cat} value={cat}>
              {cat === 'all' ? 'Toutes les catégories' : cat}
            </option>
          ))}
        </select>

        <div style={bookStyles.viewToggleWrap}>
          <button
            onClick={() => setViewMode('table')}
            style={{
              ...bookStyles.iconButton,
              ...(viewMode === 'table' ? bookStyles.iconButtonActive : {})
            }}
            title="Vue tableau"
          >
            <FaList />
          </button>
          <button
            onClick={() => setViewMode('grid')}
            style={{
              ...bookStyles.iconButton,
              ...(viewMode === 'grid' ? bookStyles.iconButtonActive : {})
            }}
            title="Vue grille"
          >
            <FaTh />
          </button>
        </div>

        {selected.length > 0 && (
          <button onClick={handleBulkDelete} style={bookStyles.bulkDeleteBtn}>
            <FaTrash style={{ marginRight: 6 }} />
            Supprimer ({selected.length})
          </button>
        )}
      </div>

      {/* ========== VUE TABLE ========== */}
      {viewMode === 'table' && (
        <div style={styles.tableContainer}>
          <table style={styles.table}>
            <thead style={styles.tableHeader}>
              <tr>
                <th style={styles.th}>
                  <input
                    type="checkbox"
                    checked={allVisibleSelected}
                    onChange={(e) => toggleSelectAll(e.target.checked)}
                  />
                </th>
                <th style={styles.th}>Titre</th>
                <th style={styles.th}>Auteur</th>
                <th style={styles.th}>Catégorie(s)</th>
                <th style={styles.th}>Taille</th>
                <th style={styles.th}>Téléchargements</th>
                <th style={styles.th}>Date d'ajout</th>
                <th style={styles.thCenter}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((b, idx) => (
                <tr key={b._id} style={idx % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                  <td style={styles.td}>
                    <input
                      type="checkbox"
                      checked={selected.includes(b._id)}
                      onChange={() => toggleOne(b._id)}
                    />
                  </td>

                  <td style={styles.td}>
                    <div style={bookStyles.titleCellWrap}>
                      <img
                        src={getImageUrl(b.imagePath)}
                        alt={b.titre}
                        style={bookStyles.tableMiniCover}
                        onError={(e) => { 
                          e.currentTarget.src = 'https://via.placeholder.com/48x64?text=PDF';
                        }}
                      />
                      <div>
                        <div style={bookStyles.titleText}>{b.titre}</div>
                        <div style={bookStyles.fileNameText}>{b.pdfOriginalName}</div>
                      </div>
                    </div>
                  </td>

                  <td style={styles.td}>{b.auteur}</td>

                  <td style={styles.td}>
                    <span style={{ ...bookStyles.badge, ...bookStyles.badgeCategory }}>
                      {getCategoryNames(b.categories)}
                    </span>
                  </td>

                  <td style={styles.td}>
                    {b.pdfSize ? `${(b.pdfSize / 1024 / 1024).toFixed(1)} MB` : 'N/A'}
                  </td>

                  <td style={styles.td}>
                    <div style={bookStyles.statsCell}>
                      <FaDownload style={{ marginRight: 6 }} /> {b.downloadCount || 0}
                    </div>
                  </td>

                  <td style={styles.td}>
                    {new Date(b.uploadedAt).toLocaleDateString('fr-FR')}
                  </td>

                  <td style={styles.tdCenter}>
                    <a 
                      href={getImageUrl(b.pdfPath)} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      style={{ textDecoration: 'none' }}
                    >
                      <button style={bookStyles.smallIconBtn} title="Télécharger">
                        <FaDownload />
                      </button>
                    </a>{' '}
                    <button
                      style={{ ...bookStyles.smallIconBtn, color: '#b91c1c' }}
                      title="Supprimer"
                      onClick={() => handleDelete(b._id, b.titre)}
                    >
                      <FaTrash />
                    </button>
                  </td>
                </tr>
              ))}

              {filtered.length === 0 && (
                <tr>
                  <td style={styles.td} colSpan={8}>
                    <div style={styles.emptyState}>Aucun livre trouvé</div>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {/* ========== VUE GRILLE ========== */}
      {viewMode === 'grid' && (
        <div style={bookStyles.grid}>
          {filtered.map((b) => (
            <GridCard 
              key={b._id} 
              book={b} 
              categories={categories}
              onDelete={handleDelete} 
            />
          ))}
          {filtered.length === 0 && (
            <div style={styles.emptyState}>Aucun livre trouvé</div>
          )}
        </div>
      )}

      {/* ========== MODAL UPLOAD ========== */}
      {showUploadModal && (
        <UploadBookModal 
          categories={categories}
          onClose={() => setShowUploadModal(false)}
          onSuccess={() => {
            loadData();
            setShowUploadModal(false);
          }}
        />
      )}
    </div>
  );
}

// ========== COMPOSANT CARTE POUR VUE GRILLE ==========
function GridCard({ book, categories, onDelete }) {
  const [hover, setHover] = useState(false);
  
 const getCategoryNames = (bookCategories) => {
    if (!bookCategories || bookCategories.length === 0) return 'Non classé';
    
    if (typeof bookCategories[0] === 'object' && bookCategories[0].nom) {
      return bookCategories.map(cat => cat.nom).join(', ');
    }
    
    const names = bookCategories.map(catId => {
      const cat = categories.find(c => c._id === catId);
      return cat ? cat.nom : '';
    }).filter(name => name);
    
    return names.length > 0 ? names.join(', ') : 'Non classé';
  };
  
  return (
    <div
      style={{ 
        ...bookStyles.card, 
        ...(hover ? bookStyles.cardHover : {}) 
      }}
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
    >
      <div style={bookStyles.coverWrap}>
        <img
          src={getImageUrl(book.imagePath)}
          alt={book.titre}
          style={bookStyles.coverImg}
          onError={(e) => { 
            e.currentTarget.src = 'https://via.placeholder.com/260x180?text=PDF';
          }}
        />
        <div style={bookStyles.coverCategory}>
          <span style={{ ...bookStyles.badge, ...bookStyles.badgeCategory }}>
            {getCategoryNames(book.categories)}
          </span>
        </div>
      </div>

      <div style={bookStyles.cardBody}>
        <div style={bookStyles.cardTitle} title={book.titre}>{book.titre}</div>
        <div style={bookStyles.cardAuthor}>{book.auteur}</div>

        <div style={bookStyles.cardFooter}>
          <span style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <FaFilePdf /> 
            {book.pdfSize ? `${(book.pdfSize / 1024 / 1024).toFixed(1)} MB` : 'N/A'}
          </span>
          <div style={bookStyles.cardActions}>
            <a 
              href={getImageUrl(book.pdfPath)} 
              target="_blank" 
              rel="noopener noreferrer"
            >
              <button style={bookStyles.smallIconBtn} title="Télécharger">
                <FaDownload />
              </button>
            </a>
            <button
              style={{ ...bookStyles.smallIconBtn, color: '#b91c1c' }}
              title="Supprimer"
              onClick={() => onDelete(book._id, book.titre)}
            >
              <FaTrash />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

// ========== MODAL UPLOAD LIVRE ==========
function UploadBookModal({ categories, onClose, onSuccess }) {
  const [formData, setFormData] = useState({
    titre: '',
    auteur: '',
    description: '',
    categories: []
  });
  const [pdfFile, setPdfFile] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const [uploading, setUploading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!pdfFile || !imageFile) {
      alert('Veuillez sélectionner un PDF et une image de couverture');
      return;
    }

    if (formData.categories.length === 0) {
      alert('Veuillez sélectionner au moins une catégorie');
      return;
    }

    setUploading(true);
    
    const data = new FormData();
    data.append('titre', formData.titre);
    data.append('auteur', formData.auteur);
    data.append('description', formData.description);
    
    formData.categories.forEach(catId => {
      data.append('categories', catId);
    });
    
    data.append('pdf', pdfFile);
    data.append('image', imageFile);

    try {
      await uploadLivre(data);
      alert('Livre uploadé avec succès !');
      onSuccess();
    } catch (error) {
      alert('Erreur lors de l\'upload');
      console.error(error);
    } finally {
      setUploading(false);
    }
  };

  const toggleCategory = (catId) => {
    setFormData(prev => ({
      ...prev,
      categories: prev.categories.includes(catId) 
        ? prev.categories.filter(id => id !== catId)
        : [...prev.categories, catId]
    }));
  };

  return (
    <div style={modalStyles.overlay} onClick={onClose}>
      <div style={modalStyles.modal} onClick={(e) => e.stopPropagation()}>
        <button style={modalStyles.closeBtn} onClick={onClose}>
          <FaTimes />
        </button>
        
        <h2 style={modalStyles.modalTitle}>Ajouter un Livre</h2>
        
        <form onSubmit={handleSubmit}>
          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Titre *</label>
            <input
              type="text"
              required
              style={modalStyles.input}
              value={formData.titre}
              onChange={(e) => setFormData({...formData, titre: e.target.value})}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Auteur *</label>
            <input
              type="text"
              required
              style={modalStyles.input}
              value={formData.auteur}
              onChange={(e) => setFormData({...formData, auteur: e.target.value})}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Description</label>
            <input
              type="text"
              style={modalStyles.input}
              value={formData.description}
              onChange={(e) => setFormData({...formData, description: e.target.value})}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Catégories *</label>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', marginTop: '8px' }}>
              {categories.map(cat => (
                <label key={cat._id} style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
                  <input
                    type="checkbox"
                    checked={formData.categories.includes(cat._id)}
                    onChange={() => toggleCategory(cat._id)}
                  />
                  {cat.nom}
                </label>
              ))}
            </div>
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Fichier PDF *</label>
            <input
              type="file"
              required
              accept="application/pdf"
              onChange={(e) => setPdfFile(e.target.files[0])}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Image de couverture *</label>
            <input
              type="file"
              required
              accept="image/*"
              onChange={(e) => setImageFile(e.target.files[0])}
            />
          </div>

          <button 
            type="submit" 
            style={modalStyles.uploadBtn}
            disabled={uploading}
          >
            {uploading ? 'Upload en cours...' : 'Uploader le livre'}
          </button>
        </form>
      </div>
    </div>
  );
}