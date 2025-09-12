import 'package:just_audio/just_audio.dart';
import '../../data/models/audio_model.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;
  AudioPlayerManager._internal();

  final AudioPlayer _player = AudioPlayer();
  AudioModel? currentAudio;

  AudioPlayer get player => _player;

  Future<void> playAudio(AudioModel audio) async {
    try {
      currentAudio = audio;
      await _player.setUrl(audio.getAudioUrl());
      await _player.play();
    } catch (e) {
      print('Erreur lecture audio: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    currentAudio = null;
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void dispose() {
    _player.dispose();
  }
}
