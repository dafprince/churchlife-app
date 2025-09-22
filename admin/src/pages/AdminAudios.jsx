import React, { useState, useEffect, useMemo } from 'react';
import { styles, audioStyles, modalStyles } from '../css/style';
import { FaPlus, FaTrash } from 'react-icons/fa';
import { getAudios, uploadAudio, deleteAudio, getImageUrl, getEglises } from '../services/api';

const AdminAudios = () => {
  const [audios, setAudios] = useState([]);
  const [eglises, setEglises] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedEglise, setSelectedEglise] = useState('all');

  useEffect(() => {
    async function fetchData() {
      try {
        const [audioData, eglisesData] = await Promise.all([getAudios(), getEglises()]);
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

  const filteredAudios = useMemo(() => {
    return audios.filter(audio => {
      const matchesSearch = audio.titre.toLowerCase().includes(search.toLowerCase()) ||
        audio.artiste.toLowerCase().includes(search.toLowerCase());

      const matchesEglise = selectedEglise === 'all' || 
        (audio.eglises && audio.eglises.some(e => e._id === selectedEglise));

      return matchesSearch && matchesEglise;
    });
  }, [audios, search, selectedEglise]);

  const handleDelete = async (id, titre) => {
    if (!window.confirm(`Supprimer l’audio "${titre}" ?`)) return;
    try {
      await deleteAudio(id);
      setAudios(prev => prev.filter(a => a._id !== id));
    } catch {
      alert('Erreur suppression audio');
    }
  };

  if (loading) return <div style={styles.emptyState}>Chargement des audios...</div>;

  return (
    <div style={audioStyles.container}>
      <div style={audioStyles.header}>
        <h2 style={audioStyles.title}>Gestion des Audios</h2>

        <input
          type="text"
          placeholder="Rechercher titre ou artiste"
          value={search}
          onChange={e => setSearch(e.target.value)}
          style={{ padding: 8, borderRadius: 6, border: '1px solid #ccc', marginRight: 12 }}
        />

        <select
          value={selectedEglise}
          onChange={e => setSelectedEglise(e.target.value)}
          style={{ padding: 8, borderRadius: 6, border: '1px solid #ccc' }}
        >
          <option value="all">Toutes les églises</option>
          {eglises.map(e => (
            <option key={e._id} value={e._id}>{e.nom}</option>
          ))}
        </select>

        <button style={modalStyles.addBtn} onClick={() => setShowModal(true)}>
          <FaPlus /> Ajouter Audio
        </button>
      </div>

      <div style={audioStyles.grid}>
        {filteredAudios.length === 0 ? (
          <div style={{ padding: 40, fontStyle: 'italic' }}>Aucun audio trouvé</div>
        ) : filteredAudios.map(audio => (
          <AudioCard key={audio._id} audio={audio} onDelete={handleDelete} />
        ))}
      </div>

      {showModal && (
        <UploadModal
          isOpen={showModal}
          onClose={() => setShowModal(false)}
          onUploadSuccess={async () => {
            const updatedAudios = await getAudios();
            setAudios(updatedAudios);
            setShowModal(false);
          }}
          eglises={eglises}
        />
      )}
    </div>
  );
};

const AudioCard = ({ audio, onDelete }) => {
  const [hover, setHover] = useState(false);
  const imageUrl = getImageUrl(audio.imagePath);
  const audioUrl = getImageUrl(audio.audioPath);

  return (
    <div
      style={{ ...audioStyles.card, ...(hover ? audioStyles.cardHover : {}) }}
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
    >
      <img
        src={imageUrl}
        alt={audio.titre}
        style={audioStyles.cardImage}
        onError={e => { e.currentTarget.src = 'https://via.placeholder.com/300x200?text=No+Image'; }}
      />
      <div style={audioStyles.cardBody}>
        <h3 style={audioStyles.cardTitle}>{audio.titre}</h3>
        <p style={audioStyles.cardArtist}>{audio.artiste}</p>

        <div>
          <b>Églises : </b>
          {(audio.eglises && audio.eglises.length > 0) ?
            audio.eglises.map(e => e.nom).join(', ') : 'Aucune'}
        </div>

        <audio controls style={audioStyles.audioPlayer}>
          <source src={audioUrl} type={audio.audioMimeType} />
          Votre navigateur ne supporte pas l'audio.
        </audio>

        <div style={audioStyles.cardActions}>
          <button
            style={audioStyles.deleteBtn}
            onClick={() => onDelete(audio._id, audio.titre)}
            onMouseEnter={e => e.target.style.backgroundColor = '#dc2626'}
            onMouseLeave={e => e.target.style.backgroundColor = '#ef4444'}
          >
            Supprimer
          </button>
        </div>
      </div>
    </div>
  );
};

const UploadModal = ({ isOpen, onClose, onUploadSuccess, eglises }) => {
  const [formData, setFormData] = useState({
    titre: '',
    artiste: '',
    album: '',
    genre: '',
    description: '',
    eglises: []
  });
  const [audioFile, setAudioFile] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const [uploading, setUploading] = useState(false);

  if (!isOpen) return null;

  const toggleEglise = (id) => {
    setFormData(prev => ({
      ...prev,
      eglises: prev.eglises.includes(id)
        ? prev.eglises.filter(e => e !== id)
        : [...prev.eglises, id]
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!audioFile || !imageFile) {
      alert('Veuillez choisir un fichier audio et une image');
      return;
    }
    if (formData.eglises.length === 0) {
      alert('Veuillez sélectionner au moins une église');
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

    formData.eglises.forEach(id => data.append('eglises', id));

    try {
      await uploadAudio(data);
      alert('Audio ajouté avec succès !');
      onUploadSuccess();
      onClose();
      setFormData({ titre: '', artiste: '', album: '', genre: '', description: '', eglises: [] });
      setAudioFile(null);
      setImageFile(null);
    } catch {
      alert('Erreur lors de l\'upload');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div style={modalStyles.overlay} onClick={onClose}>
      <div style={modalStyles.modal} onClick={e => e.stopPropagation()}>
        <button style={modalStyles.closeBtn} onClick={onClose}>×</button>
        <h2 style={modalStyles.modalTitle}>Ajouter un Audio</h2>

        <form onSubmit={handleSubmit}>
          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Titre *</label>
            <input
              type="text"
              required
              value={formData.titre}
              onChange={e => setFormData({ ...formData, titre: e.target.value })}
              style={modalStyles.input}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Artiste *</label>
            <input
              type="text"
              required
              value={formData.artiste}
              onChange={e => setFormData({ ...formData, artiste: e.target.value })}
              style={modalStyles.input}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Album</label>
            <input
              type="text"
              value={formData.album}
              onChange={e => setFormData({ ...formData, album: e.target.value })}
              style={modalStyles.input}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Genre</label>
            <input
              type="text"
              value={formData.genre}
              onChange={e => setFormData({ ...formData, genre: e.target.value })}
              style={modalStyles.input}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Description</label>
            <input
              type="text"
              value={formData.description}
              onChange={e => setFormData({ ...formData, description: e.target.value })}
              style={modalStyles.input}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Sélectionner Église(s) *</label>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10, maxHeight: 120, overflowY: 'auto' }}>
              {eglises.map(e => (
                <label key={e._id} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <input
                    type="checkbox"
                    checked={formData.eglises.includes(e._id)}
                    onChange={() => toggleEglise(e._id)}
                  />
                  {e.nom}
                </label>
              ))}
            </div>
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Fichier Audio *</label>
            <input
              type="file"
              accept="audio/*"
              required
              onChange={e => setAudioFile(e.target.files[0])}
              style={modalStyles.fileInput}
            />
          </div>

          <div style={modalStyles.formGroup}>
            <label style={modalStyles.label}>Image de couverture *</label>
            <input
              type="file"
              accept="image/*"
              required
              onChange={e => setImageFile(e.target.files[0])}
              style={modalStyles.fileInput}
            />
          </div>

          <button type="submit" style={modalStyles.uploadBtn} disabled={uploading}>
            {uploading ? 'Upload en cours...' : 'Uploader'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default AdminAudios;
