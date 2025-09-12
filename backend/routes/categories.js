// routes/categories.js
const express = require('express');
const router = express.Router();
const Category = require('../models/Category');
const upload = require('../config/multerConfig');
const fs = require('fs');

// ============= POST - Créer une catégorie =============
router.post('/create', upload.single('image'), async (req, res) => {
  try {
    // Vérifier si l'image est présente
    if (!req.file) {
      return res.status(400).json({ 
        message: 'Image de catégorie requise' 
      });
    }

    // Vérifier si le nom existe déjà
    const existingCategory = await Category.findOne({ nom: req.body.nom });
    if (existingCategory) {
      // Supprimer l'image uploadée si la catégorie existe déjà
      fs.unlinkSync(req.file.path);
      return res.status(400).json({ 
        message: 'Cette catégorie existe déjà' 
      });
    }

    const imageFile = req.file;

    // Créer la nouvelle catégorie
    const newCategory = new Category({
      nom: req.body.nom,
      description: req.body.description || '',
      
      imageFileName: imageFile.filename,
      imageOriginalName: imageFile.originalname,
      imagePath: imageFile.path,
      imageSize: imageFile.size,
      imageMimeType: imageFile.mimetype
    });

    const savedCategory = await newCategory.save();
    
    res.status(201).json({
      message: 'Catégorie créée avec succès',
      category: savedCategory
    });

  } catch (error) {
    // Si erreur, supprimer l'image uploadée
    if (req.file && req.file.path) {
      try {
        fs.unlinkSync(req.file.path);
      } catch (err) {
        console.error('Erreur suppression image:', err);
      }
    }
    
    console.error('Erreur création catégorie:', error);
    res.status(500).json({ 
      message: 'Erreur lors de la création',
      error: error.message 
    });
  }
});

// ============= GET - Récupérer toutes les catégories =============
router.get('/', async (req, res) => {
  try {
    const categories = await Category.find({ isActive: true })
      .sort({ nom: 1 });  // Tri alphabétique
    
    res.json(categories);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération',
      error: error.message 
    });
  }
});

// ============= GET - Récupérer une catégorie par ID =============
router.get('/', async (req, res) => {
  try {
    const livres = await Livre.find({ isActive: true })
      .populate('categories', 'nom')  // ← IMPORTANT : Cette ligne doit être là
      .populate('uploadedBy', 'name email')
      .sort({ uploadedAt: -1 });
    
    res.json(livres);
  } catch (error) {
    res.status(500).json({ 
      message: 'Erreur lors de la récupération',
      error: error.message 
    });
  }
});

// ============= PUT - Modifier une catégorie =============
router.put('/:id', upload.single('image'), async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    
    if (!category) {
      // Si nouvelle image uploadée mais catégorie n'existe pas
      if (req.file) fs.unlinkSync(req.file.path);
      return res.status(404).json({ message: 'Catégorie non trouvée' });
    }

    // Mettre à jour les champs texte
    if (req.body.nom) category.nom = req.body.nom;
    if (req.body.description) category.description = req.body.description;

    // Si nouvelle image, remplacer l'ancienne
    if (req.file) {
      // Supprimer l'ancienne image
      try {
        if (fs.existsSync(category.imagePath)) {
          fs.unlinkSync(category.imagePath);
        }
      } catch (err) {
        console.error('Erreur suppression ancienne image:', err);
      }

      // Mettre à jour avec la nouvelle image
      category.imageFileName = req.file.filename;
      category.imageOriginalName = req.file.originalname;
      category.imagePath = req.file.path;
      category.imageSize = req.file.size;
      category.imageMimeType = req.file.mimetype;
    }

    const updatedCategory = await category.save();
    
    res.json({
      message: 'Catégorie mise à jour',
      category: updatedCategory
    });

  } catch (error) {
    if (req.file) fs.unlinkSync(req.file.path);
    res.status(500).json({ 
      message: 'Erreur lors de la mise à jour',
      error: error.message 
    });
  }
});

// ============= DELETE - Supprimer une catégorie =============
router.delete('/:id', async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    
    if (!category) {
      return res.status(404).json({ message: 'Catégorie non trouvée' });
    }

    // Vérifier si des livres utilisent cette catégorie
    const Livre = require('../models/Livre');
    const livresAvecCategorie = await Livre.countDocuments({ 
      categories: req.params.id 
    });

    if (livresAvecCategorie > 0) {
      return res.status(400).json({ 
        message: `Impossible de supprimer : ${livresAvecCategorie} livre(s) utilisent cette catégorie` 
      });
    }

    // Supprimer l'image
    try {
      if (fs.existsSync(category.imagePath)) {
        fs.unlinkSync(category.imagePath);
        console.log('Image catégorie supprimée:', category.imagePath);
      }
    } catch (fileError) {
      console.error('Erreur suppression image:', fileError);
    }
    
    // Supprimer de MongoDB
    await Category.findByIdAndDelete(req.params.id);
    
    res.json({ 
      message: 'Catégorie supprimée avec succès',
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

module.exports = router;