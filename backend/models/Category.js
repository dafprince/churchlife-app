const mongoose = require('mongoose');

const CategorySchema = new mongoose.Schema({
  nom: {
    type: String,
    required: true,
    unique: true  // Pas de doublons
  },
  description: {
    type: String,
    default: ''
  },
  
  // Image de la catégorie
  imageFileName: {
    type: String,
    required: true
  },
  imageOriginalName: {
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
  imageMimeType: {
    type: String,
    required: true
  },
  
  // Métadonnées
  createdAt: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

module.exports = mongoose.model('Category', CategorySchema, 'categories');