require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');               
const { Server } = require('socket.io');    
const usersRouter = require('./routes/users');
const audiosRouter = require('./routes/audios');
// Ajoutez ces deux lignes avec vos autres imports
const categoriesRouter = require('./routes/categories');
const livresRouter = require('./routes/livres');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware pour servir les fichiers statiques
app.use('/uploads', express.static('uploads'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use((req, res, next) => {
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  next();
});

// --- Socket.IO ---
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

// Rendre io accessible dans les routes
app.set('io', io);

io.on('connection', (socket) => {
  console.log('⚡ Utilisateur connecté via WebSocket');
  socket.on('disconnect', () => {
    console.log('❌ Utilisateur déconnecté');
  });
});

// Routes
app.use('/api/users', usersRouter);
app.use('/api/audios', audiosRouter); 
// AJOUTEZ CES DEUX LIGNES
app.use('/api/categories', categoriesRouter);
app.use('/api/livres', livresRouter);
app.get('/', (req, res) => {
  res.send('Serveur Express + Mongo : OK cest parfait');
});

// Connexion MongoDB
mongoose.connect(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => {
  console.log('✅ Connecté à MongoDB');
  server.listen(PORT, () => {
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
  });
})
.catch(err => {
  console.error('❌ Erreur connexion MongoDB :', err.message);
});
