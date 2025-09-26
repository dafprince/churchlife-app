import 'package:mobile/features/audios/data/models/audio_model.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final List<AudioModel> audios;

  AudioLoaded(this.audios);
}

class AudioError extends AudioState {
  final String message;

  AudioError(this.message);
}
