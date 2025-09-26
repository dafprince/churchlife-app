import '../datasources/audio_api_service.dart';
import '../models/audio_model.dart';

class AudioRepository {
  final AudioApiService apiService;

  AudioRepository(this.apiService);

  Future<List<AudioModel>> getAudios() {
    return apiService.getAudios();
  }

  /// Récupère les audios liés à une église spécifique
  Future<List<AudioModel>> getAudiosByEglise(String egliseId) {
    return apiService.getAudiosByEglise(egliseId);
  }
}
