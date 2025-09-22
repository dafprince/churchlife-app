const express = require('express');
const router = express.Router();
const Eglise = require('../models/Eglise');
const upload = require('../config/multerConfig');
const fs = require('fs');

// POST : créer une église (upload image)
router.post('/create', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'Image d’église requise' });
    }

    const existing = await Eglise.findOne({ nom: req.body.nom });
    if (existing) {
      fs.unlinkSync(req.file.path);
      return res.status(400).json({ message: 'Église déjà existante' });
    }

    const imageFile = req.file;

    const newEglise = new Eglise({
      nom: req.body.nom,
      imageFileName: imageFile.filename,
      imageOriginalName: imageFile.originalname,
      imagePath: imageFile.path,
      imageSize: imageFile.size,
      imageMimeType: imageFile.mimetype
    });

    const saved = await newEglise.save();
    res.status(201).json({ message: 'Église créée', eglise: saved });
  } catch (error) {
    if (req.file && req.file.path) {
      try {
        fs.unlinkSync(req.file.path);
      } catch (err) {
        console.error('Erreur suppression image:', err);
      }
    }
    console.error('Erreur création église:', error);
    res.status(500).json({ message: 'Erreur création église', error: error.message });
  }
});

// GET : récupérer toutes les églises
router.get('/', async (req, res) => {
  try {
    const eglises = await Eglise.find({ isActive: true }).sort({ nom: 1 });
    res.json(eglises);
  } catch (error) {
    res.status(500).json({ message: 'Erreur récupération églises', error: error.message });
  }
});

// DELETE : supprimer une église
router.delete('/:id', async (req, res) => {
  try {
    const eglise = await Eglise.findById(req.params.id);
    if (!eglise) return res.status(404).json({ message: 'Église non trouvée' });

    // Ici, tu peux ajouter la vérification d'utilisation (si lié à des audios) plus tard

    try {
      if (fs.existsSync(eglise.imagePath)) {
        fs.unlinkSync(eglise.imagePath);
        console.log('Image église supprimée:', eglise.imagePath);
      }
    } catch (fileErr) {
      console.error('Erreur suppression image:', fileErr);
    }

    await Eglise.findByIdAndDelete(req.params.id);
    res.json({ message: 'Église supprimée', id: req.params.id });
  } catch (error) {
    res.status(500).json({ message: 'Erreur suppression église', error: error.message });
  }
});

module.exports = router;
