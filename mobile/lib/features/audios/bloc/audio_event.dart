abstract class AudioEvent {}

class LoadAudiosEvent extends AudioEvent {}

class LoadAudiosByEgliseEvent extends AudioEvent {
  final String egliseId;

  LoadAudiosByEgliseEvent(this.egliseId);
}
