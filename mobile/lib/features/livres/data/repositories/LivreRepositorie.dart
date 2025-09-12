import '../datasources/LivreApiService.dart';
import '../models/livre_model.dart';

class LivreRepository {
  final LivreApiService apiService;

  LivreRepository(this.apiService);

  /// Récupérer les livres d'une catégorie spécifique
  ///
  /// [categoryId] : L'ID MongoDB de la catégorie
  /// Cette méthode fait le lien entre le BLoC et l'API
  Future<List<LivreModel>> getLivresByCategory(String categoryId) async {
    try {
      return await apiService.getLivresByCategory(categoryId);
    } catch (e) {
      // Transformation de l'erreur en message plus clair pour l'utilisateur
      throw Exception(
        "Impossible de récupérer les livres de cette catégorie: $e",
      );
    }
  }
}
