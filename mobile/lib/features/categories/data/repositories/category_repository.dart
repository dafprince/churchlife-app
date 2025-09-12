import '../datasources/category_api_service.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryApiService apiService;

  CategoryRepository(this.apiService);

  /// Méthode pour récupérer toutes les catégories
  ///
  /// Cette méthode fait le lien entre le BLoC et l'API
  /// Plus tard, on pourrait ajouter du cache ou d'autres vérifications ici
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await apiService.getCategories();
    } catch (e) {
      throw Exception("Impossible de récupérer les catégories: $e");
    }
  }
}
