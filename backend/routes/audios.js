// routes/audios.js
const express = require('express');
const router = express.Router();
const Audio = require('../models/Audio');
const upload = require('../config/multerConfig');
const fs = require('fs');  // ← AJOUTEZ CETTE LIGNE il permet de supprimer les supprimer dans les dossier sinon ca va pas le faire

// Route POST pour upload audio + image
router.post('/upload', upload.fields([
  { name: 'audio', maxCount: 1 },
  { name: 'image', maxCount: 1 }
]), async (req, res) => {
  try {
    // Vérifier que les deux fichiers sont présents
    if (!req.files.audio || !req.files.image) {
      return res.status(400).json({ 
        message: 'Audio et image sont requis' 
      });
    }

    // Récupérer les fichiers uploadés
    const audioFile = req.files.audio[0];
    const imageFile = req.files.image[0];

    // Créer le nouveau document audio
    const newAudio = new Audio({
      // Infos de base (depuis le formulaire)
      titre: req.body.titre,
      artiste: req.body.artiste,
      album: req.body.album || '',
      genre: req.body.genre || '',
      description: req.body.description || '',
      
      // Infos du fichier audio
      audioFileName: audioFile.filename,
      audioOriginalName: audioFile.originalname,
      audioPath: audioFile.path,
      audioSize: audioFile.size,
      audioMimeType: audioFile.mimetype,
      
      // Infos de l'image
      imageFileName: imageFile.filename,
      imageOriginalName: imageFile.originalname,
      imagePath: imageFile.path,
      imageSize: imageFile.size,
      imageMimeType: imageFile.mimetype,
      
      // Pour le moment, mettez un ID utilisateur fixe pour tester
      // Plus tard, ce sera req.user._id quand vous aurez l'authentification
      uploadedBy: "68979387425d91d89f0fab39" // REMPLACEZ par un vrai ID de votre collection users CEST FAIT*
    });

    // Sauvegarder dans MongoDB
    const savedAudio = await newAudio.save();
    
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

// Route GET pour récupérer tous les audios
router.get('/', async (req, res) => {
  try {
    const audios = await Audio.find({ isActive: true })
      .populate('uploadedBy', 'name email')  // Récupère les infos de l'utilisateur
      .sort({ uploadedAt: -1 });  // Plus récent en premier
    
    res.json(audios);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération des audios',
      error: error.message 
    });
  }
});

// ========== AJOUTEZ CETTE ROUTE DELETE ICI ==========


// Route DELETE pour supprimer un audio
router.delete('/:id', async (req, res) => {
  try {
    // Chercher l'audio dans la base de données
    const audio = await Audio.findById(req.params.id);
    
    if (!audio) {
      return res.status(404).json({ 
        message: 'Audio non trouvé' 
      });
    }
    
    // Supprimer les fichiers physiques
    try {
      // Supprimer le fichier audio s'il existe
      if (fs.existsSync(audio.audioPath)) {
        fs.unlinkSync(audio.audioPath);
        console.log('Fichier audio supprimé:', audio.audioPath);
      }
      
      // Supprimer l'image si elle existe
      if (fs.existsSync(audio.imagePath)) {
        fs.unlinkSync(audio.imagePath);
        console.log('Image supprimée:', audio.imagePath);
      }
    } catch (fileError) {
      console.error('Erreur lors de la suppression des fichiers:', fileError);
      // On continue même si les fichiers n'existent pas
    }
    
    // Supprimer l'entrée de MongoDB
    await Audio.findByIdAndDelete(req.params.id);
    
    console.log('Audio supprimé de la DB:', req.params.id);
    
    res.json({ 
      message: 'Audio supprimé avec succès',
      id: req.params.id 
    });
    
  } catch (error) {
    console.error('Erreur DELETE:', error);
    res.status(500).json({ 
      message: 'Erreur lors de la suppression',
      error: error.message 
    });
  }
});
// ========== FIN DE LA ROUTE DELETE ==========

module.exports = router;