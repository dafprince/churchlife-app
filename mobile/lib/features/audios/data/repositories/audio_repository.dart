import '../datasources/audio_api_service.dart';
import '../models/audio_model.dart';

class AudioRepository {
  final AudioApiService apiService;

  AudioRepository(this.apiService);

  /// Récupérer tous les audios
  /// Cette méthode fait le lien entre le BLoC et l'API
  Future<List<AudioModel>> getAudios() async {
    try {
      return await apiService.getAudios();
    } catch (e) {
      throw Exception("Impossible de récupérer les audios: $e");
    }
  }
}
