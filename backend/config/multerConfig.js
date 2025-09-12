// config/multerConfig.js
const multer = require('multer');
const path = require('path');

// Configuration pour le stockage des fichiers
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    // Déterminer le dossier selon le type de fichier
    if (file.fieldname === 'audio') {
      cb(null, 'uploads/audios/');
    } else if (file.fieldname === 'image') {
      // IMPORTANT : 'image' va dans différents dossiers selon la route
      if (req.url.includes('categories')) {
        cb(null, 'uploads/categories/');  // Pour les catégories
      } else {
        cb(null, 'uploads/images/');      // Pour les audios/livres
      }
    } else if (file.fieldname === 'pdf') {
      cb(null, 'uploads/livres/');
    } else {
      cb(new Error('Type de fichier non reconnu'), false);
    }
  },
  
  filename: function(req, file, cb) {
    // Créer un nom unique : timestamp-nomoriginal
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

// Filtre pour valider les types de fichiers
const fileFilter = (req, file, cb) => {
  if (file.fieldname === 'audio') {
    // Accepter seulement les formats audio
    if (file.mimetype === 'audio/mpeg' || 
        file.mimetype === 'audio/mp3' || 
        file.mimetype === 'audio/wav' ||
        file.mimetype === 'audio/ogg') {
      cb(null, true);
    } else {
      cb(new Error('Format audio non supporté. Utilisez MP3, WAV ou OGG'), false);
    }
  } else if (file.fieldname === 'image') {  // ← Retirez categoryImage d'ici
    // Accepter seulement les images
    if (file.mimetype === 'image/jpeg' || 
        file.mimetype === 'image/png' || 
        file.mimetype === 'image/jpg') {
      cb(null, true);
    } else {
      cb(new Error('Format image non supporté. Utilisez JPG, JPEG ou PNG'), false);
    }
  } else if (file.fieldname === 'pdf') {
    if (file.mimetype === 'application/pdf') {
      cb(null, true);
    } else {
      cb(new Error('Format non supporté. Utilisez PDF uniquement'), false);
    }
  } else {  // ← AJOUTEZ CE ELSE FINAL !
    cb(new Error(`Champ non reconnu: ${file.fieldname}`), false);
  }
};

// Configuration finale
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 50 * 1024 * 1024  // Limite 50MB par fichier
  }
});

module.exports = upload;