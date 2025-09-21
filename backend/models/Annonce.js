const mongoose = require('mongoose');

const annonceSchema = new mongoose.Schema({
  image: {
    type: String,
    required: true
  },
  texte: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Annonce', annonceSchema);
