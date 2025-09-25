// features/annonces/data/repositories/annonce_repository.dart
import '../datasources/annonce_api_service.dart';
import '../models/annonce_model.dart';

class AnnonceRepository {
  final AnnonceApiService apiService;

  AnnonceRepository(this.apiService);

  /// Récupère toutes les annonces
  Future<List<AnnonceModel>> getAnnonces() async {
    try {
      return await apiService.getAnnonces();
    } catch (e) {
      throw Exception("Impossible de récupérer les annonces: $e");
    }
  }
}
