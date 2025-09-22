const express = require('express');
const router = express.Router();
const Annonce = require('../models/Annonce');

// POST : Ajouter une annonce
router.post('/', async (req, res) => {
  try {
    const { image, texte } = req.body;

    if (!image || !texte) {
      return res.status(400).json({ error: 'Image et texte sont requis' });
    }

    const annonce = new Annonce({ image, texte });
    const savedAnnonce = await annonce.save();

    res.status(201).json(savedAnnonce);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur lors de la création' });
  }
});

// DELETE : Supprimer une annonce par ID
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Annonce.findByIdAndDelete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ error: 'Annonce non trouvée' });
    }
    res.json({ message: 'Annonce supprimée avec succès' });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur lors de la suppression' });
  }
});

// Récupérer toutes les annonces
router.get('/', async (req, res) => {
  try {
    const annonces = await Annonce.find(); // sans filtre : tout
    res.json(annonces);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur lors de la récupération des annonces' });
  }
});

module.exports = router;
