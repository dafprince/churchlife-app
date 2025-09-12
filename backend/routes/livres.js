// routes/livres.js
const express = require('express');
const router = express.Router();
const Livre = require('../models/Livre');
const upload = require('../config/multerConfig');
const fs = require('fs');

// ============= POST - Upload d'un livre =============
router.post('/upload', upload.fields([
  { name: 'pdf', maxCount: 1 },
  { name: 'image', maxCount: 1 }
]), async (req, res) => {
  try {
    // Vérifier les fichiers
    if (!req.files.pdf || !req.files.image) {
      return res.status(400).json({ 
        message: 'PDF et image de couverture sont requis' 
      });
    }

    const pdfFile = req.files.pdf[0];
    const imageFile = req.files.image[0];

    // Gérer les catégories (peut être un tableau ou une seule valeur)
    let categoriesArray = [];
    if (req.body.categories) {
      // Si c'est une string, la convertir en tableau
      if (typeof req.body.categories === 'string') {
        categoriesArray = [req.body.categories];
      } else {
        categoriesArray = req.body.categories;
      }
    }

    // Créer le nouveau livre
    const newLivre = new Livre({
      titre: req.body.titre,
      auteur: req.body.auteur,
      description: req.body.description || '',
      categories: categoriesArray,  // Tableau d'IDs de catégories
      
      // Infos PDF
      pdfFileName: pdfFile.filename,
      pdfOriginalName: pdfFile.originalname,
      pdfPath: pdfFile.path,
      pdfSize: pdfFile.size,
      pdfMimeType: pdfFile.mimetype,
      
      // Infos image
      imageFileName: imageFile.filename,
      imageOriginalName: imageFile.originalname,
      imagePath: imageFile.path,
      imageSize: imageFile.size,
      imageMimeType: imageFile.mimetype,
      
      uploadedBy: "68979387425d91d89f0fab3a" // Remplacez par req.user._id en production
    });

    const savedLivre = await newLivre.save();
    
    res.status(201).json({
      message: 'Livre uploadé avec succès',
      livre: savedLivre
    });

  } catch (error) {
    console.error('Erreur upload livre:', error);
    res.status(500).json({ 
      message: 'Erreur lors de l\'upload',
      error: error.message 
    });
  }
});

// ============= GET - Récupérer tous les livres =============
router.get('/', async (req, res) => {
  try {
    const livres = await Livre.find({ isActive: true })
      .populate('categories', 'nom')  // Récupère le nom des catégories
      .populate('uploadedBy', 'name email')
      .sort({ uploadedAt: -1 });
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.json(livres);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération',
      error: error.message 
    });
  }
});

// ============= GET - Récupérer un livre par ID =============
router.get('/:id', async (req, res) => {
  try {
    const livre = await Livre.findById(req.params.id)
      .populate('categories', 'nom description')
      .populate('uploadedBy', 'name email');
    
    if (!livre) {
      return res.status(404).json({ message: 'Livre non trouvé' });
    }
    
    res.json(livre);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur',
      error: error.message 
    });
  }
});

// ============= PUT - Incrémenter le compteur de téléchargement =============
router.put('/:id/download', async (req, res) => {
  try {
    const livre = await Livre.findByIdAndUpdate(
      req.params.id,
      { $inc: { downloadCount: 1 } },  // Incrémente de 1
      { new: true }
    );
    
    if (!livre) {
      return res.status(404).json({ message: 'Livre non trouvé' });
    }
    
    res.json({ 
      message: 'Compteur mis à jour',
      downloadCount: livre.downloadCount 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur',
      error: error.message 
    });
  }
});

// ============= DELETE - Supprimer un livre =============
router.delete('/:id', async (req, res) => {
  try {
    const livre = await Livre.findById(req.params.id);
    
    if (!livre) {
      return res.status(404).json({ message: 'Livre non trouvé' });
    }
    
    // Supprimer les fichiers physiques
    try {
      if (fs.existsSync(livre.pdfPath)) {
        fs.unlinkSync(livre.pdfPath);
        console.log('PDF supprimé:', livre.pdfPath);
      }
      
      if (fs.existsSync(livre.imagePath)) {
        fs.unlinkSync(livre.imagePath);
        console.log('Image supprimée:', livre.imagePath);
      }
    } catch (fileError) {
      console.error('Erreur suppression fichiers:', fileError);
    }
    
    // Supprimer de MongoDB
    await Livre.findByIdAndDelete(req.params.id);
    
    res.json({ 
      message: 'Livre supprimé avec succès',
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
// Dans routes/livres.js - AJOUTER cette route
// ============= GET - Livres par catégorie =============
router.get('/category/:categoryId', async (req, res) => {
  try {
    const livres = await Livre.find({ 
      categories: req.params.categoryId,  // Livres contenant cette catégorie
      isActive: true 
    })
      .populate('categories', 'nom')
      .populate('uploadedBy', 'name email')
      .sort({ uploadedAt: -1 });
    
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.json(livres);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération',
      error: error.message 
    });
  }
});

module.exports = router;