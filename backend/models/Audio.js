const mongoose = require('mongoose');

const AudioSchema = new mongoose.Schema({
  // Informations de base
  titre: {
    type: String,
    required: true
  },
  artiste: {
    type: String,
    required: true
  },
  album: {
    type: String,
    default: ''
  },
  genre: {
    type: String,
    default: ''
  },
  description: {
    type: String,
    default: ''
  },
  
  // Fichier audio
  audioFileName: {
    type: String,
    required: true
  },
  audioOriginalName: {
    type: String,
    required: true
  },
  audioPath: {
    type: String,
    required: true
  },
  audioSize: {
    type: Number,
    required: true
  },
  audioMimeType: {
    type: String,
    required: true
  },
  duration: {
    type: Number,
    default: 0
  },
  
  // Image de couverture
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
  uploadedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',  // Assurez-vous que c'est le même nom que votre modèle User
    required: true
  },
  uploadedAt: {
    type: Date,
    default: Date.now
  },
  lastModified: {
    type: Date,
    default: Date.now
  },
  playCount: {
    type: Number,
    default: 0
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

// Créer le modèle

// Export avec nom explicite de collection
module.exports = mongoose.model('Audio', AudioSchema, 'audios');