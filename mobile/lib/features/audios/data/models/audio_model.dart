import 'package:mobile/core/api_constants.dart';

/// Modèle complet Audio avec relation vers plusieurs Eglises
class AudioModel {
  final String id;
  final String titre;
  final String artiste;
  final String album;
  final String genre;
  final String description;
  final String audioFileName;
  final String audioPath;
  final int duration;
  final String imageFileName;
  final String imagePath;
  final DateTime uploadedAt;
  final List<EgliseInfo> eglises; // Relation many-to-many to Eglises

  AudioModel({
    required this.id,
    required this.titre,
    required this.artiste,
    required this.album,
    required this.genre,
    required this.description,
    required this.audioFileName,
    required this.audioPath,
    required this.duration,
    required this.imageFileName,
    required this.imagePath,
    required this.uploadedAt,
    required this.eglises,
  });

  /// Crée l'instance AudioModel depuis JSON
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    var eglisesJson = json['eglises'] as List<dynamic>? ?? [];

    return AudioModel(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? '',
      artiste: json['artiste'] ?? '',
      album: json['album'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      audioFileName: json['audioFileName'] ?? '',
      audioPath: json['audioPath'] ?? '',
      duration: json['duration'] ?? 0,
      imageFileName: json['imageFileName'] ?? '',
      imagePath: json['imagePath'] ?? '',
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? '') ?? DateTime.now(),
      eglises: eglisesJson.map((e) => EgliseInfo.fromJson(e)).toList(),
    );
  }

  /// URL complet audio (tenant compte du serveur)
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    // Supposons que imagePath contient déjà le chemin complet comme "uploads/images/filename.jpg"
    return '$baseUrl/$imagePath';
  }

  String getAudioUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/$audioPath';
  }

  /// Durée formatée mm:ss
  String getFormattedDuration() {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Classe simplifiée représentant une Eglise associée à un Audio
class EgliseInfo {
  final String id;
  final String nom;
  final String imagePath;

  EgliseInfo({required this.id, required this.nom, required this.imagePath});

  factory EgliseInfo.fromJson(Map<String, dynamic> json) {
    return EgliseInfo(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  /// URL complet image église
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/$imagePath';
  }
}
