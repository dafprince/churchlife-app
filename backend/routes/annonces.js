const express = require('express');
const router = express.Router();
const Annonce = require('../models/Annonce');
const upload = require('../config/multerConfig'); // si tu veux uploader l’image en local

// Route POST pour créer annonce avec upload d'image
router.post('/upload', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'Image requise !' });
    }
    if (!req.body.texte) {
      return res.status(400).json({ message: 'Texte requis !' });
    }

    // Chemin image locale (ex: "uploads/images/xyz.png")
    const newAnnonce = new Annonce({
      image: req.file.path,
      texte: req.body.texte
    });

    const saved = await newAnnonce.save();
    res.status(201).json({ message: 'Annonce créée !', annonce: saved });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de création annonce', error: error.message });
  }
});

// Route GET pour toutes les annonces
router.get('/', async (req, res) => {
  try {
    // optionnel : trier par date
    const annonces = await Annonce.find().sort({ createdAt: -1 });
    res.json(annonces);
  } catch (error) {
    res.status(500).json({ message: 'Erreur récupération annonces', error: error.message });
  }
});

// Route DELETE pour supprimer annonce
router.delete('/:id', async (req, res) => {
  try {
    const annonce = await Annonce.findById(req.params.id);
    if (!annonce) {
      return res.status(404).json({ message: 'Annonce non trouvée' });
    }
    // Si besoin, supprimer le fichier image en local (optionnel)
    // fs.unlinkSync(annonce.image);
    await Annonce.findByIdAndDelete(req.params.id);
    res.json({ message: 'Annonce supprimée' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur suppression', error: error.message });
  }
});

module.exports = router;
