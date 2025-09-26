const express = require('express');
const router = express.Router();
const Audio = require('../models/Audio');
const upload = require('../config/multerConfig');
const fs = require('fs');  // Pour supprimer les fichiers physiques
const ffprobe = require('node-ffprobe');

// ============================================
// POST - Upload audio + image + association églises
// ============================================
router.post('/upload', upload.fields([
  { name: 'audio', maxCount: 1 },
  { name: 'image', maxCount: 1 }
]), async (req, res) => {
  try {
    if (!req.files.audio || !req.files.image) {
      return res.status(400).json({ message: 'Audio et image sont requis' });
    }

    const audioFile = req.files.audio[0];
    const imageFile = req.files.image[0];
    // Calculer la durée
let audioDuration = 0;
try {
  const probeData = await ffprobe(audioFile.path);
  audioDuration = Math.round(probeData.streams[0].duration || 0);
} catch (error) {
  console.error('Erreur calcul durée:', error);
}
    let eglisesArray = [];
    if (req.body.eglises) {
      eglisesArray = typeof req.body.eglises === 'string' ? [req.body.eglises] : req.body.eglises;
    }

    // Étapes date
    const receivedDateStr = req.body.publicationDate;
    console.log('Date reçue dans la requête:', receivedDateStr);

    let publicationDate = null;
    if (receivedDateStr) {
      const tempDate = new Date(receivedDateStr);
      if (!isNaN(tempDate.getTime())) {
        publicationDate = tempDate;
      } else {
        console.warn('Date reçue invalide:', receivedDateStr);
      }
    }

    const newAudio = new Audio({
      titre: req.body.titre,
      artiste: req.body.artiste,
      album: req.body.album || '',
      genre: req.body.genre || '',
      description: req.body.description || '',
      audioFileName: audioFile.filename,
      audioOriginalName: audioFile.originalname,
      audioPath: audioFile.path,
      audioSize: audioFile.size,
      audioMimeType: audioFile.mimetype,
      duration: audioDuration,
      imageFileName: imageFile.filename,
      imageOriginalName: imageFile.originalname,
      imagePath: imageFile.path,
      imageSize: imageFile.size,
      imageMimeType: imageFile.mimetype,
      eglises: eglisesArray,
      uploadedBy: "68979387425d91d89f0fab39",
      publicationDate,  // <- date validée ou null,
    });

    const savedAudio = await newAudio.save();

    console.log('Audio sauvegardé:', savedAudio);

    res.status(201).json({
      message: 'Audio uploadé avec succès',
      audio: savedAudio
    });

  } catch (error) {
    console.error('Erreur upload:', error);
    res.status(500).json({ 
      message: 'Erreur lors de l\'upload',
      error: error.message 
    });
  }
});

// ============================================
// GET - Récupérer tous les audios avec relations
// ============================================
router.get('/', async (req, res) => {
  try {
    const audios = await Audio.find({ isActive: true })
      .populate('uploadedBy', 'name email')  // Infos utilisateur
      .populate('eglises', 'nom imagePath')  // Infos églises liées (nom + image)
      .sort({ uploadedAt: -1 });  // Tri du plus récent au plus ancien

    res.json(audios);

  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération des audios',
      error: error.message 
    });
  }
});

// ============================================
// GET - Récupérer un audio unique par ID
// ============================================
router.get('/:id', async (req, res) => {
  try {
    const audio = await Audio.findById(req.params.id)
      .populate('uploadedBy', 'name email')
      .populate('eglises', 'nom imagePath');

    if (!audio) {
      return res.status(404).json({ message: 'Audio non trouvé' });
    }

    res.json(audio);

  } catch (error) {
    res.status(500).json({
      message: 'Erreur récupération audio',
      error: error.message
    });
  }
});

// ============================================
// DELETE - Supprimer un audio et ses fichiers physiques
// ============================================
router.delete('/:id', async (req, res) => {
  try {
    const audio = await Audio.findById(req.params.id);

    if (!audio) {
      return res.status(404).json({ message: 'Audio non trouvé' });
    }

    // Supprimer fichier audio physique
    try {
      if (fs.existsSync(audio.audioPath)) {
        fs.unlinkSync(audio.audioPath);
        console.log('Fichier audio supprimé:', audio.audioPath);
      }
      if (fs.existsSync(audio.imagePath)) {
        fs.unlinkSync(audio.imagePath);
        console.log('Image audio supprimée:', audio.imagePath);
      }
    } catch (fileError) {
      console.error('Erreur suppression fichiers:', fileError);
    }

    await Audio.findByIdAndDelete(req.params.id);

    res.json({
      message: 'Audio supprimé avec succès',
      id: req.params.id
    });

  } catch (error) {
    res.status(500).json({
      message: 'Erreur lors de la suppression',
      error: error.message
    });
  }
});

// Dans routes/audios.js modification audio js 
router.put('/:id', async (req, res) => {
  try {
    const audio = await Audio.findById(req.params.id);
    if (!audio) {
      return res.status(404).json({ message: 'Audio non trouvé' });
    }

    // Mise à jour des champs simples s'ils sont fournis
    if (req.body.titre !== undefined) audio.titre = req.body.titre;
    if (req.body.artiste !== undefined) audio.artiste = req.body.artiste;
    if (req.body.album !== undefined) audio.album = req.body.album;
    if (req.body.genre !== undefined) audio.genre = req.body.genre;
    if (req.body.description !== undefined) audio.description = req.body.description;

    // Mise à jour relation eglises (array d'id)
    if (req.body.eglises !== undefined) {
      audio.eglises = Array.isArray(req.body.eglises)
        ? req.body.eglises
        : [req.body.eglises];
    }

    const updatedAudio = await audio.save();

    res.json({
      message: 'Audio mis à jour avec succès',
      audio: updatedAudio
    });
  } catch (error) {
    console.error('Erreur mise à jour audio:', error);
    res.status(500).json({
      message: 'Erreur lors de la mise à jour',
      error: error.message
    });
  }
});

// Route pour récupérer les audios d'une église spécifique
router.get('/byEglise/:egliseId', async (req, res) => {
  try {
    const audios = await Audio.find({ 
      isActive: true,
      eglises: req.params.egliseId 
    })
    .populate('eglises', 'nom imageFileName')
    .sort({ uploadedAt: -1 });
    
    res.json(audios);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur récupération audios par église', 
      error: error.message 
    });
  }
});
module.exports = router;
