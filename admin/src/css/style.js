export const styles = {
  container: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '24px',
    backgroundColor: 'white',
    fontFamily: 'Arial, sans-serif'
  },
  title: {
    fontSize: '32px',
    fontWeight: 'bold',
    color: '#1f2937',
    marginBottom: '32px',
    textAlign: 'center'
  },
  tableContainer: {
  marginBottom: '32px',
  boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
  borderRadius: '8px',
  overflow: 'auto',  // ← Changez 'hidden' en 'auto'
  maxWidth: '100%'   // ← Ajoutez cette ligne
},
  table: {
    width: '100%',
    borderCollapse: 'collapse',
    backgroundColor: 'white'
  },
  tableHeader: {
    backgroundColor: '#2563eb',
    color: 'white'
  },
  th: {
    border: '1px solid #d1d5db',
    padding: '12px 16px',
    textAlign: 'left',
    fontWeight: '600',
    fontSize: '14px'
  },
  thCenter: {
    border: '1px solid #d1d5db',
    padding: '12px 16px',
    textAlign: 'center',
    fontWeight: '600',
    fontSize: '14px'
  },
  td: {
    border: '1px solid #d1d5db',
    padding: '12px 16px',
    color: '#374151'
  },
  tdCenter: {
    border: '1px solid #d1d5db',
    padding: '12px 16px',
    textAlign: 'center'
  },
  rowEven: {
    backgroundColor: '#f9fafb'
  },
  rowOdd: {
    backgroundColor: 'white'
  },
  btnEdit: {
    backgroundColor: '#eab308',
    color: 'white',
    padding: '6px 12px',
    border: 'none',
    borderRadius: '4px',
    marginRight: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500'
  },
  btnDelete: {
    backgroundColor: '#ef4444',
    color: 'white',
    padding: '6px 12px',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500'
  },
  formContainer: {
    backgroundColor: '#f9fafb',
    padding: '24px',
    borderRadius: '8px',
    boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)'
  },
  formTitle: {
    fontSize: '20px',
    fontWeight: '600',
    color: '#1f2937',
    marginBottom: '16px'
  },
  inputContainer: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
    gap: '16px',
    marginBottom: '16px'
  },
  label: {
    display: 'block',
    fontSize: '14px',
    fontWeight: '500',
    color: '#374151',
    marginBottom: '4px'
  },
  input: {
    width: '100%',
    padding: '8px 12px',
    border: '1px solid #d1d5db',
    borderRadius: '6px',
    fontSize: '14px',
    boxSizing: 'border-box',
    outline: 'none'
  },
  buttonContainer: {
    display: 'flex',
    gap: '8px',
    paddingTop: '16px'
  },
  btnPrimary: {
    backgroundColor: '#2563eb',
    color: 'white',
    padding: '10px 24px',
    border: 'none',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500'
  },
  btnSecondary: {
    backgroundColor: '#6b7280',
    color: 'white',
    padding: '10px 24px',
    border: 'none',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500'
  },
  stats: {
    marginTop: '24px',
    textAlign: 'center',
    color: '#6b7280',
    fontSize: '14px'
  },
  emptyState: {
    textAlign: 'center',
    padding: '32px',
    color: '#6b7280',
    backgroundColor: '#f9fafb'
  }
};
// Ajoutez ces nouveaux styles à votre style.js existant

export const dashboardStyles = {
  // Layout principal
  layoutContainer: {
    minHeight: '100vh',
    display: 'flex',
    backgroundColor: '#f3f4f6'
  },
  
  // Sidebar
sidebar: {
  width: '256px',
  background: 'linear-gradient(180deg, #1f2937 0%, #374151 100%)',
  color: 'white',
  padding: '24px',
  boxShadow: '4px 0 6px -1px rgba(0, 0, 0, 0.1)',
  display: 'flex',
  flexDirection: 'column',
  minHeight: '100vh'  // ← Changez height en minHeight
},
  
  sidebarTitle: {
    fontSize: '28px',
    fontWeight: 'bold',
    background: 'linear-gradient(90deg, #60a5fa 0%, #a78bfa 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    marginBottom: '8px'
  },
  
  navMenu: {
    marginTop: '40px',
    display: 'flex',
    flexDirection: 'column',
    gap: '8px'
  },
  
  navItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    padding: '12px 16px',
    borderRadius: '12px',
    cursor: 'pointer',
    transition: 'all 0.2s',
    backgroundColor: 'transparent',
    border: 'none',
    color: 'white',
    width: '100%',
    fontSize: '15px',
    fontWeight: '500'
  },
  
  navItemActive: {
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    backdropFilter: 'blur(10px)',
    border: '1px solid rgba(255, 255, 255, 0.2)'
  },
  
  // Zone de contenu principal
 mainContent: {
  flex: 1,
  marginLeft: '0',  // ← Changez 256px en 0
  padding: '32px',
  overflowY: 'auto'
},
  
  // Header avec stats
  statsHeader: {
    marginBottom: '32px'
  },
  
  statsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
    gap: '24px',
    marginBottom: '32px'
  },
  
  // Carte de statistique
  statCard: {
    backgroundColor: 'white',
    borderRadius: '16px',
    boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
    padding: '24px',
    position: 'relative',
    overflow: 'hidden',
    transition: 'all 0.3s',
    cursor: 'pointer'
  },
  
  statCardHover: {
    boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1)',
    transform: 'translateY(-2px)'
  },
  
  statIcon: {
    width: '48px',
    height: '48px',
    borderRadius: '12px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: '16px'
  },
  
  statValue: {
    fontSize: '32px',
    fontWeight: 'bold',
    marginBottom: '4px'
  },
  
  statLabel: {
    fontSize: '14px',
    color: '#6b7280'
  },
  
  // Badge pour les indicateurs
  badge: {
    position: 'absolute',
    top: '16px',
    right: '16px',
    padding: '4px 8px',
    borderRadius: '9999px',
    fontSize: '12px',
    fontWeight: '600'
  },
  
  badgeSuccess: {
    backgroundColor: '#d1fae5',
    color: '#065f46'
  },
  
  badgeDanger: {
    backgroundColor: '#fee2e2',
    color: '#991b1b'
  }
};
// Ajoutez ces styles pour AdminAudios
export const audioStyles = {
  container: {
    width: '100%',
    padding: '24px'
  },
  
  header: {
    marginBottom: '32px'
  },
  
  title: {
    fontSize: '28px',
    fontWeight: 'bold',
    color: '#1f2937',
    marginBottom: '8px'
  },
  
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
    gap: '24px',
    marginBottom: '32px'
  },
  
  card: {
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
    overflow: 'hidden',
    transition: 'transform 0.2s, box-shadow 0.2s'
  },
  
  cardHover: {
    transform: 'translateY(-4px)',
    boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)'
  },
  
  cardImage: {
    width: '100%',
    height: '200px',
    objectFit: 'cover',
    backgroundColor: '#f3f4f6'
  },
  
  cardBody: {
    padding: '16px'
  },
  
  cardTitle: {
    fontSize: '18px',
    fontWeight: '600',
    color: '#1f2937',
    marginBottom: '4px'
  },
  
  cardArtist: {
    fontSize: '14px',
    color: '#6b7280',
    marginBottom: '12px'
  },
  
  audioPlayer: {
    width: '100%',
    marginBottom: '12px'
  },
  
  cardActions: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  
  deleteBtn: {
    backgroundColor: '#ef4444',
    color: 'white',
    border: 'none',
    padding: '8px 16px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '14px',
    transition: 'background-color 0.2s'
  },
  
  playCount: {
    fontSize: '12px',
    color: '#9ca3af'
  },
  
  uploadForm: {
    backgroundColor: '#f9fafb',
    padding: '24px',
    borderRadius: '12px',
    marginBottom: '32px'
  }
};
// Ajoutez ces styles pour le modal
export const modalStyles = {
  overlay: {
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000
  },
  
  modal: {
    backgroundColor: 'white',
    borderRadius: '12px',
    padding: '32px',
    maxWidth: '500px',
    width: '90%',
    maxHeight: '90vh',
    overflow: 'auto',
    position: 'relative'
  },
  
  closeBtn: {
    position: 'absolute',
    top: '16px',
    right: '16px',
    background: 'none',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
    color: '#6b7280'
  },
  
  modalTitle: {
    fontSize: '24px',
    fontWeight: 'bold',
    marginBottom: '24px',
    color: '#1f2937'
  },
  
  formGroup: {
    marginBottom: '16px'
  },
  
  label: {
    display: 'block',
    marginBottom: '4px',
    fontSize: '14px',
    fontWeight: '500',
    color: '#374151'
  },
  
  input: {
    width: '100%',
    padding: '8px 12px',
    border: '1px solid #d1d5db',
    borderRadius: '6px',
    fontSize: '14px',
    boxSizing: 'border-box'
  },
  
  fileInput: {
    marginBottom: '8px'
  },
  
  uploadBtn: {
    backgroundColor: '#10b981',
    color: 'white',
    border: 'none',
    padding: '10px 24px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '16px',
    fontWeight: '500',
    width: '100%',
    marginTop: '16px'
  },
  
  addBtn: {
    backgroundColor: '#3b82f6',
    color: 'white',
    border: 'none',
    padding: '10px 20px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '16px',
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    marginBottom: '24px'
  }
};
//=======
// Styles pour la page Livres (table + grille)
export const bookStyles = {
  container: {
    width: '100%',
    padding: '24px'
  },

  // Header + bouton "Ajouter"
  header: {
    backgroundColor: 'white',
    border: '1px solid #e5e7eb',
    borderRadius: '12px',
    padding: '16px',
    marginBottom: '24px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    boxShadow: '0 1px 2px rgba(0,0,0,0.04)'
  },
  headerTitleWrap: { },
  headerTitle: {
    fontSize: '20px',
    fontWeight: '700',
    color: '#111827'
  },
  headerSub: {
    fontSize: '13px',
    color: '#6b7280',
    marginTop: '4px'
  },
  addBtn: {
    backgroundColor: '#2563eb',
    color: 'white',
    border: 'none',
    padding: '10px 16px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600',
    display: 'flex',
    alignItems: 'center',
    gap: '8px'
  },

  // Toolbar (recherche, filtre, toggles, suppression multiple)
  toolbar: {
    backgroundColor: 'white',
    border: '1px solid #e5e7eb',
    borderRadius: '12px',
    padding: '12px 16px',
    marginBottom: '24px',
    display: 'flex',
    flexWrap: 'wrap',
    gap: '12px',
    alignItems: 'center',
    boxShadow: '0 1px 2px rgba(0,0,0,0.04)'
  },
  searchWrapper: {
    position: 'relative',
    flex: 1,
    minWidth: '240px'
  },
  searchIcon: {
    position: 'absolute',
    left: '10px',
    top: '50%',
    transform: 'translateY(-50%)',
    color: '#9ca3af'
  },
  searchInput: {
    width: '100%',
    padding: '10px 12px 10px 36px',
    border: '1px solid #d1d5db',
    borderRadius: '8px',
    fontSize: '14px',
    outline: 'none'
  },
  select: {
    padding: '10px 12px',
    border: '1px solid #d1d5db',
    borderRadius: '8px',
    fontSize: '14px',
    backgroundColor: 'white'
  },
  viewToggleWrap: {
    display: 'flex',
    gap: '8px',
    marginLeft: 'auto'
  },
  iconButton: {
    padding: '8px 10px',
    borderRadius: '8px',
    border: '1px solid #e5e7eb',
    background: 'white',
    cursor: 'pointer',
    color: '#6b7280'
  },
  iconButtonActive: {
    backgroundColor: 'rgba(59,130,246,0.1)',
    border: '1px solid #bfdbfe',
    color: '#2563eb'
  },
  bulkDeleteBtn: {
    backgroundColor: '#ef4444',
    color: 'white',
    border: 'none',
    padding: '10px 14px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600'
  },

  // Badges
  badge: {
    display: 'inline-block',
    padding: '4px 8px',
    borderRadius: '9999px',
    fontSize: '12px',
    fontWeight: '600'
  },
  badgePublished: { backgroundColor: '#d1fae5', color: '#065f46' },
  badgeDraft: { backgroundColor: '#fef9c3', color: '#92400e' },
  badgeCategory: { backgroundColor: '#dbeafe', color: '#1e40af' },

  // Table (réutilise tes styles.table*, mais on garde quelques helpers)
  tableMiniCover: {
    width: '48px',
    height: '64px',
    borderRadius: '6px',
    objectFit: 'cover',
    backgroundColor: '#f3f4f6',
    boxShadow: '0 1px 2px rgba(0,0,0,0.08)',
    flexShrink: 0
  },
  titleCellWrap: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px'
  },
  titleText: { fontWeight: 600, color: '#111827' },
  fileNameText: { fontSize: '12px', color: '#6b7280' },
  statsCell: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    color: '#6b7280'
  },

  // Grid
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
    gap: '16px'
  },
  card: {
    backgroundColor: 'white',
    border: '1px solid #e5e7eb',
    borderRadius: '12px',
    overflow: 'hidden',
    boxShadow: '0 1px 2px rgba(0,0,0,0.04)',
    transition: 'transform .2s, box-shadow .2s'
  },
  cardHover: {
    transform: 'translateY(-2px)',
    boxShadow: '0 10px 15px -3px rgba(0,0,0,0.1)'
  },
  coverWrap: {
    position: 'relative',
    height: '180px',
    backgroundColor: '#f3f4f6'
  },
  coverImg: {
    width: '100%',
    height: '100%',
    objectFit: 'cover'
  },
  coverCategory: {
    position: 'absolute',
    top: '8px',
    left: '8px'
  },
  cardBody: {
    padding: '12px'
  },
  cardTitle: {
    fontWeight: '700',
    fontSize: '16px',
    color: '#111827',
    marginBottom: '4px',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis'
  },
  cardAuthor: { fontSize: '13px', color: '#6b7280', marginBottom: '8px' },
  cardFooter: {
    marginTop: '8px',
    paddingTop: '8px',
    borderTop: '1px solid #f3f4f6',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    color: '#6b7280',
    fontSize: '13px'
  },
  cardActions: {
    display: 'flex',
    gap: '8px'
  },
  smallIconBtn: {
    background: 'white',
    border: '1px solid #e5e7eb',
    borderRadius: '8px',
    padding: '6px 8px',
    cursor: 'pointer',
    color: '#374151'
  }
};
