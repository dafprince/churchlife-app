import React, { useState } from 'react';
import AdminUsers from '../pages/AdminUsers';
import { dashboardStyles } from '../css/style';
import { FaUsers, FaMusic, FaBook } from 'react-icons/fa';
import { useEffect } from 'react';  // Ajoutez useEffect
import { getUsers, getAudios } from '../services/api';
import AdminAudios from '../pages/AdminAudios';  // Ajoutez cette ligne
import AdminBooks from '../pages/AdminBooks';
import CategorieLivresPage from '../pages/CategorieLivresPage';


const DashboardLayout = () => {
  const [currentPage, setCurrentPage] = useState('users');
  const [users, setUsers] = useState([]);
const [audios, setAudios] = useState([]);
const [loading, setLoading] = useState(true);
useEffect(() => {
  const loadData = async () => {
    try {
      const usersData = await getUsers();
      setUsers(usersData);
      
      try {
        const audiosData = await getAudios();
        setAudios(audiosData);
      } catch {
        setAudios([]);
      }
    } catch (error) {
      console.error('Erreur:', error);
    } finally {
      setLoading(false);
    }
  };
  
  loadData();
}, [currentPage]);  // ← AJOUTEZ currentPage ici
  return (
    <div style={dashboardStyles.layoutContainer}>
      {/* Sidebar */}
      <aside style={dashboardStyles.sidebar}>
        <h1 style={dashboardStyles.sidebarTitle}>Dashboard</h1>
        {/* Après le h1 Dashboard, ajoutez : */}
<nav style={dashboardStyles.navMenu}>
  <button
    onClick={() => setCurrentPage('users')}
    style={{
      ...dashboardStyles.navItem,
      ...(currentPage === 'users' ? dashboardStyles.navItemActive : {})
    }}
  >
    <FaUsers />
    <span>Utilisateurs</span>
  </button>

  <button
    onClick={() => setCurrentPage('audios')}
    style={{
      ...dashboardStyles.navItem,
      ...(currentPage === 'audios' ? dashboardStyles.navItemActive : {})
    }}
  >
    <FaMusic />
    <span>Audios</span>
  </button>

  <button
    onClick={() => setCurrentPage('books')}
    style={{
      ...dashboardStyles.navItem,
      ...(currentPage === 'books' ? dashboardStyles.navItemActive : {})
    }}
  >
    <FaBook />
    <span>Livres</span>
  </button>
  <button onClick={() => setCurrentPage("categories")}>Catégories</button>

  
</nav>
      </aside>

      {/* Contenu */}
     <main style={dashboardStyles.mainContent}>
       {/* Ajoutez ceci */}
  {loading && <div style={{ padding: '20px', textAlign: 'center' }}>Chargement...</div>}
        {/* Stats */}
  <div style={dashboardStyles.statsGrid}>
    <div style={dashboardStyles.statCard}>
      <div style={{ fontSize: '32px', fontWeight: 'bold', color: '#3b82f6' }}>
        {users.length}
      </div>
      <div style={{ color: '#6b7280', marginTop: '8px' }}>
        Total Utilisateurs
      </div>
    </div>

    <div style={dashboardStyles.statCard}>
      <div style={{ fontSize: '32px', fontWeight: 'bold', color: '#10b981' }}>
        {audios.length}
      </div>
      <div style={{ color: '#6b7280', marginTop: '8px' }}>
        Total Audios
      </div>
    </div>
  </div>

  {currentPage === 'users' && <AdminUsers />}
 {currentPage === 'audios' && <AdminAudios />}
 {currentPage === 'books' && <AdminBooks />}
 {currentPage === "categories" && <CategorieLivresPage />}

</main>
    </div>
  );
};
//  {currentPage === 'books' && <div>Page Livres (à créer)</div>}

export default DashboardLayout;