import '../../../../core/api_constants.dart';

class LivreModel {
  final String id;
  final String titre;
  final String auteur;
  final String description;
  final List<CategoryInfo>
  categories; // Changé de List<String> à List<CategoryInfo>
  final String imageFileName;
  final String pdfFileName;
  final DateTime uploadedAt;
  final int downloadCount;
  final bool isActive;

  LivreModel({
    required this.id,
    required this.titre,
    required this.auteur,
    required this.description,
    required this.categories,
    required this.imageFileName,
    required this.pdfFileName,
    required this.uploadedAt,
    required this.downloadCount,
    required this.isActive,
  });

  factory LivreModel.fromJson(Map<String, dynamic> json) {
    // Traitement spécial pour les catégories
    List<CategoryInfo> categoriesList = [];
    if (json['categories'] != null) {
      categoriesList = (json['categories'] as List)
          .map((cat) => CategoryInfo.fromJson(cat))
          .toList();
    }

    return LivreModel(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? '',
      auteur: json['auteur'] ?? '',
      description: json['description'] ?? '',
      categories: categoriesList,
      imageFileName: json['imageFileName'] ?? '',
      pdfFileName: json['pdfFileName'] ?? '',
      uploadedAt: DateTime.parse(
        json['uploadedAt'] ?? DateTime.now().toIso8601String(),
      ),
      downloadCount: json['downloadCount'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  String getImageUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/images/$imageFileName';
  }

  String getPdfUrl() {
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/uploads/livres/$pdfFileName';
  }

  // Méthode utilitaire pour obtenir les noms des catégories
  String getCategoryNames() {
    if (categories.isEmpty) return 'Non classé';
    return categories.map((cat) => cat.nom).join(', ');
  }
}

// Classe pour représenter les infos de catégorie dans un livre
class CategoryInfo {
  final String id;
  final String nom;

  CategoryInfo({required this.id, required this.nom});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(id: json['_id'] ?? '', nom: json['nom'] ?? '');
  }
}
