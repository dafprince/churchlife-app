import '../../../../core/api_constants.dart';

/// Modèle pour représenter une catégorie
class CategoryModel {
  final String id;
  final String nom;
  final String description;
  final String imageFileName;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.imageFileName,
    required this.isActive,
  });

  /// Créer un CategoryModel à partir d'un JSON (venant de l'API)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      imageFileName: json['imageFileName'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
  // IMAGE POINTER VERS LE SERVEUR PRODUCTION PAS LOCAL
  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/images/$imageFileName';
  }
}
