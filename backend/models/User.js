// models/User.js
const mongoose = require('mongoose');

// 1. Définition du schéma : structure d'un document "user"
const UserSchema = new mongoose.Schema({
  name:  { type: String, required: true }, // champ "nom"
  email: { type: String, required: true },
  age: { type: Number, required: true },


   // champ "mail"
});

// 2. Export du modèle
//    - 'User' : nom du modèle en JS
//    - UserSchema : le schéma ci-dessus
//    - 'users' : nom explicite de la collection Mongo (évite toute confusion)
module.exports = mongoose.model('User', UserSchema, 'users');
