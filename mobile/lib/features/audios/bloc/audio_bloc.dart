import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audios/data/repositories/audio_repository.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository repository;

  AudioBloc(this.repository) : super(AudioInitial()) {
    on<LoadAudiosEvent>((event, emit) async {
      emit(AudioLoading());
      try {
        final audios = await repository.getAudios();
        emit(AudioLoaded(audios));
      } catch (e) {
        emit(AudioError(e.toString()));
      }
    });

    on<LoadAudiosByEgliseEvent>((event, emit) async {
      emit(AudioLoading());
      try {
        final audios = await repository.getAudiosByEglise(event.egliseId);
        emit(AudioLoaded(audios));
      } catch (e) {
        emit(AudioError(e.toString()));
      }
    });
  }
}
