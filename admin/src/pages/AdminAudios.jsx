import React, { useState, useEffect } from 'react';
import { getAudios, uploadAudio, deleteAudio } from '../services/api';
import { audioStyles , modalStyles  } from '../css/style';
import { FaTrash, FaPlay , FaPlus } from 'react-icons/fa';

const AdminAudios = () => {
  const [audios, setAudios] = useState([]);
  const [loading, setLoading] = useState(true);
  // const [uploading, setUploading] = useState(false);
  const [showModal, setShowModal] = useState(false);
  
  // Charger les audios au montage
  useEffect(() => {
    fetchAudios();
  }, []);
  
  const fetchAudios = async () => {
    try {
      const data = await getAudios();
      setAudios(data);
    } catch (error) {
      console.error('Erreur:', error);
    } finally {
      setLoading(false);
    }
  };
  
  // Fonction pour supprimer
  const handleDelete = async (id, titre) => {
    if (!window.confirm(`Supprimer "${titre}" ?`)) return;
    
    try {
      await deleteAudio(id);
      setAudios(audios.filter(a => a._id !== id));
    } catch (error) {
      alert('Erreur lors de la suppression');
    }
  };
  
  if (loading) return <div>Chargement des audios...</div>;
  
  return (
    <div style={audioStyles.container}>
      <div style={audioStyles.header}>
        <h2 style={audioStyles.title}>Gestion des Audios</h2>
        <p style={{ color: '#6b7280' }}>
          {audios.length} audio(s) disponible(s)
        </p>
         {/* AJOUTEZ CE BOUTON ICI */}
  <button 
    style={modalStyles.addBtn}
    onClick={() => setShowModal(true)}
  >
    <FaPlus /> Ajouter un Audio
  </button>
      </div>
      
      {/* Grille des audios */}
      <div style={audioStyles.grid}>
        {audios.map(audio => (
          <AudioCard 
            key={audio._id} 
            audio={audio} 
            onDelete={handleDelete}
          />
        ))}
      </div>
      
      {audios.length === 0 && (
        <div style={{ textAlign: 'center', padding: '48px', color: '#6b7280' }}>
          Aucun audio pour le moment
        </div>
      )}

       {/* AJOUTEZ LE MODAL ICI, JUSTE AVANT </div> */}
      <UploadModal 
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        onUploadSuccess={() => {
          fetchAudios();
          setShowModal(false);
        }}
      />
    </div>
  );
};

// Composant pour chaque carte audio
const AudioCard = ({ audio, onDelete }) => {
  const [isHovered, setIsHovered] = useState(false);
  
  // Construire l'URL de l'image
  const imageUrl = `http://localhost:5000/${audio.imagePath}`;
  const audioUrl = `http://localhost:5000/${audio.audioPath}`;
  
  return (
    <div 
      style={{
        ...audioStyles.card,
        ...(isHovered ? audioStyles.cardHover : {})
      }}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img 
        src={imageUrl} 
        alt={audio.titre}
        style={audioStyles.cardImage}
        onError={(e) => {
          e.target.src = 'https://via.placeholder.com/300x200?text=No+Image';
        }}
      />
      
      <div style={audioStyles.cardBody}>
        <h3 style={audioStyles.cardTitle}>{audio.titre}</h3>
        <p style={audioStyles.cardArtist}>{audio.artiste}</p>
        
        <audio controls style={audioStyles.audioPlayer}>
          <source src={audioUrl} type={audio.audioMimeType} />
          Votre navigateur ne supporte pas l'audio.
        </audio>
        
        <div style={audioStyles.cardActions}>
          <button 
            style={audioStyles.deleteBtn}
            onClick={() => onDelete(audio._id, audio.titre)}
            onMouseEnter={(e) => e.target.style.backgroundColor = '#dc2626'}
            onMouseLeave={(e) => e.target.style.backgroundColor = '#ef4444'}
          >
            <FaTrash style={{ display: 'inline', marginRight: '4px' }} />
            Supprimer
          </button>
          
          <span style={audioStyles.playCount}>
            <FaPlay style={{ display: 'inline', marginRight: '4px' }} />
            {audio.playCount || 0} lectures
          </span>
        </div>
      </div>
    </div>
  );
};
// Composant Modal (ajoutez AVANT export default AdminAudios)
const UploadModal = ({ isOpen, onClose, onUploadSuccess }) => {
  const [formData, setFormData] = useState({
    titre: '',
    artiste: '',
    album: '',
    genre: '',
    description: ''
  });
  const [audioFile, setAudioFile] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const [uploading, setUploading] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!audioFile || !imageFile) {
      alert('Veuillez sélectionner un audio et une image');
      return;
    }

    setUploading(true);
    
    const data = new FormData();
    data.append('titre', formData.titre);
    data.append('artiste', formData.artiste);
    data.append('album', formData.album);
    data.append('genre', formData.genre);
    data.append('description', formData.description);
    data.append('audio', audioFile);
    data.append('image', imageFile);

    try {
      await uploadAudio(data);
      alert('Audio uploadé avec succès !');
      onUploadSuccess();
      onClose();
      // Reset form
      setFormData({
        titre: '', artiste: '', album: '', genre: '', description: ''
      });
      setAudioFile(null);
      setImageFile(null);
    } catch (error) {
      alert('Erreur lors de l\'upload');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div style={modalStyles.overlay} onClick={onClose}>
      <div style={modalStyles.modal} onClick={(e) => e.stopPropagation()}>
        <button style={modalStyles.closeBtn} onClick={onClose}>×</button>
        
        <h2 style={modalStyles.modalTitle}>Ajouter un Audio</h2>
        
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
            <label style={modalStyles.label}>Artiste *</label>
            <input
              type="text"
              required
              style={modalStyles.input}
              value={formData.artiste}
              onChange={(e) => setFormData({...formData, artiste: e.target.value})}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Album</label>
            <input
              type="text"
              style={modalStyles.input}
              value={formData.album}
              onChange={(e) => setFormData({...formData, album: e.target.value})}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Fichier Audio *</label>
            <input
              type="file"
              required
              accept="audio/*"
              style={modalStyles.fileInput}
              onChange={(e) => setAudioFile(e.target.files[0])}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Image de couverture *</label>
            <input
              type="file"
              required
              accept="image/*"
              style={modalStyles.fileInput}
              onChange={(e) => setImageFile(e.target.files[0])}
            />
          </div>

          <button 
            type="submit" 
            style={modalStyles.uploadBtn}
            disabled={uploading}
          >
            {uploading ? 'Upload en cours...' : 'Uploader'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default AdminAudios;