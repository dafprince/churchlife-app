import '../data/models/audio_model.dart';

/// Classe abstraite pour tous les états liés aux audios
abstract class AudioState {}

/// État initial - quand on n'a encore rien fait
class AudioInitial extends AudioState {}

/// État de chargement - quand on fait l'appel API
class AudioLoading extends AudioState {}

/// État de succès - quand on a reçu les audios
class AudioLoaded extends AudioState {
  final List<AudioModel> audios;

  AudioLoaded(this.audios);
}

/// État d'erreur - quand quelque chose a mal fonctionné
class AudioError extends AudioState {
  final String message;

  AudioError(this.message);
}
