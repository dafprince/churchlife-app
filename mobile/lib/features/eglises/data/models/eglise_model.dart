import '../../../../core/api_constants.dart';

class EgliseModel {
  final String id;
  final String nom;
  final String imageFileName;

  EgliseModel({
    required this.id,
    required this.nom,
    required this.imageFileName,
  });

  factory EgliseModel.fromJson(Map<String, dynamic> json) {
    return EgliseModel(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      imageFileName: json['imageFileName'] ?? '',
    );
  }

  // Génère l’URL image complète
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/images/$imageFileName';
  }
}
