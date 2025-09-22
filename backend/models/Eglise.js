const mongoose = require('mongoose');

const EgliseSchema = new mongoose.Schema({
  nom: { type: String, required: true, unique: true },
  imageFileName: { type: String, required: true },
  imageOriginalName: { type: String, required: true },
  imagePath: { type: String, required: true },
  imageSize: { type: Number, required: true },
  imageMimeType: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  isActive: { type: Boolean, default: true }
});

module.exports = mongoose.model('Eglise', EgliseSchema, 'eglises');
