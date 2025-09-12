// models/Livre.js
const mongoose = require('mongoose');

const LivreSchema = new mongoose.Schema({
  // Informations de base
  titre: {
    type: String,
    required: true,
    trim: true
  },
  auteur: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    default: ''
  },

  // Relation avec les catégories (plusieurs possibles)
  categories: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Category'
  }],

  // Fichier PDF
  pdfFileName: {
    type: String,
    required: true
  },
  pdfOriginalName: {      // ← AJOUT
    type: String,
    required: true
  },
  pdfPath: {
    type: String,
    required: true
  },
  pdfSize: {
    type: Number,
    required: true
  },
  pdfMimeType: {           // ← AJOUT
    type: String,
    required: true
  },

  // Image de couverture
  imageFileName: {
    type: String,
    required: true
  },
  imageOriginalName: {     // ← AJOUT
    type: String,
    required: true
  },
  imagePath: {
    type: String,
    required: true
  },
  imageSize: {
    type: Number,
    required: true
  },
  imageMimeType: {         // ← AJOUT
    type: String,
    required: true
  },

  // Système
  uploadedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  uploadedAt: {
    type: Date,
    default: Date.now
  },
  downloadCount: {
    type: Number,
    default: 0
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

module.exports = mongoose.model('Livre', LivreSchema, 'livres');