const mongoose = require('mongoose');
const express = require('express');
const router = express.Router();
const User = require('../models/User');

// GET /api/users
router.get('/', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// POST /api/users
router.post('/', async (req, res) => {
  try {
    const { name, email, age } = req.body;
    const newUser = new User({ name, email, age });
    const savedUser = await newUser.save();

    // Émettre l'événement "user_added"
    req.app.get('io').emit('user_added', savedUser);

    res.json(savedUser);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// DELETE /api/users/:id
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'ID invalide' });
  }
  try {
    const deleted = await User.findByIdAndDelete(id);
    if (!deleted) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    // Émettre l'événement "user_deleted"
    req.app.get('io').emit('user_deleted', id);

    return res.json({ message: 'Supprimé', user: deleted });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
});

// PUT /api/users/:id
router.put('/:id', async (req, res) => {
  try {
    const { name, email, age } = req.body;
    if (!name || !email || typeof age === 'undefined') {
      return res.status(400).json({ message: 'name, email et age sont requis' });
    }

    const updated = await User.findByIdAndUpdate(
      req.params.id,
      { name, email, age },
      { new: true, runValidators: true }
    );

    if (!updated) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    // Émettre l'événement "user_updated"
    req.app.get('io').emit('user_updated', updated);

    res.json(updated);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
