// features/annonces/data/models/annonce_model.dart
import '../../../../core/api_constants.dart';
//======= test1

class AnnonceModel {
  final String id;
  final String image; // Le nom du fichier ou chemin relatif
  final String texte;
  final DateTime createdAt;

  AnnonceModel({
    required this.id,
    required this.image,
    required this.texte,
    required this.createdAt,
  });

  factory AnnonceModel.fromJson(Map<String, dynamic> json) {
    return AnnonceModel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      texte: json['texte'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // IMAGE POINTER VERS LE SERVEUR PRODUCTION PAS LOCAL
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    // Si image contient déjà "uploads/images/", on l'utilise tel quel
    // Sinon on ajoute le préfixe
    if (image.startsWith('uploads/')) {
      return '$baseUrl/$image';
    } else {
      return '$baseUrl/uploads/images/$image';
    }
  }
}
