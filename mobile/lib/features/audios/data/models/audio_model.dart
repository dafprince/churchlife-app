import '../../../../core/api_constants.dart';

class AudioModel {
  final String id;
  final String titre;
  final String artiste;
  final String album;
  final String genre;
  final String description;

  // Fichier audio
  final String audioFileName;
  final String audioOriginalName;
  final String audioPath;
  final int audioSize;
  final String audioMimeType;
  final int duration;

  // Image de couverture
  final String imageFileName;
  final String imageOriginalName;
  final String imagePath;
  final int imageSize;
  final String imageMimeType;

  // Métadonnées
  final DateTime uploadedAt;
  final int playCount;
  final bool isActive;

  AudioModel({
    required this.id,
    required this.titre,
    required this.artiste,
    required this.album,
    required this.genre,
    required this.description,
    required this.audioFileName,
    required this.audioOriginalName,
    required this.audioPath,
    required this.audioSize,
    required this.audioMimeType,
    required this.duration,
    required this.imageFileName,
    required this.imageOriginalName,
    required this.imagePath,
    required this.imageSize,
    required this.imageMimeType,
    required this.uploadedAt,
    required this.playCount,
    required this.isActive,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? '',
      artiste: json['artiste'] ?? '',
      album: json['album'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      audioFileName: json['audioFileName'] ?? '',
      audioOriginalName: json['audioOriginalName'] ?? '',
      audioPath: json['audioPath'] ?? '',
      audioSize: json['audioSize'] ?? 0,
      audioMimeType: json['audioMimeType'] ?? '',
      duration: json['duration'] ?? 0,
      imageFileName: json['imageFileName'] ?? '',
      imageOriginalName: json['imageOriginalName'] ?? '',
      imagePath: json['imagePath'] ?? '',
      imageSize: json['imageSize'] ?? 0,
      imageMimeType: json['imageMimeType'] ?? '',
      uploadedAt: DateTime.parse(
        json['uploadedAt'] ?? DateTime.now().toIso8601String(),
      ),
      playCount: json['playCount'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  // Méthodes utilitaires pour construire les URLs
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/images/$imageFileName';
  }

  // ✅ APRÈS (utilise ApiConstants)
  String getAudioUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/audios/$audioFileName';
  }

  // Méthode pour formater la durée
  String getFormattedDuration() {
    if (duration == 0) return "Durée inconnue";
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
