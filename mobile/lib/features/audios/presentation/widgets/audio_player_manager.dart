import 'package:just_audio/just_audio.dart';
import '../../data/models/audio_model.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;
  AudioPlayerManager._internal();

  AudioPlayer? _player;
  AudioModel? currentAudio;

  AudioPlayer get player {
    _player ??= AudioPlayer(); // Créé uniquement si null
    return _player!;
  }

  Future<void> playAudio(AudioModel audio) async {
    try {
      // Si c'est le même audio ET qu'il est en pause, reprendre
      if (currentAudio?.id == audio.id &&
          player.processingState != ProcessingState.idle) {
        await resume();
        return;
      }

      // Sinon, charger le nouvel audio
      currentAudio = audio;
      await player.setUrl(audio.getAudioUrl());
      await player.play();
    } catch (e) {
      print('Erreur lecture audio: $e');
    }
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.play();
  }

  Future<void> stop() async {
    await player.stop();
    currentAudio = null;
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  // NOUVEAU : Reset au lieu de dispose pour Singleton
  Future<void> reset() async {
    try {
      await player.stop();
      await player.seek(Duration.zero);
      currentAudio = null;
    } catch (e) {
      print('Erreur reset audio: $e');
    }
  }

  // NOUVEAU : Dispose complet (seulement quand app se ferme)
  Future<void> disposeCompletely() async {
    await _player?.dispose();
    _player = null;
    currentAudio = null;
  }
}
