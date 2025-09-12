import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_event.dart';
import 'audio_state.dart';
import '../data/repositories/audio_repository.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository repository;

  AudioBloc(this.repository) : super(AudioInitial()) {
    // Gestion de l'événement LoadAudiosEvent
    on<LoadAudiosEvent>((event, emit) async {
      // 1. Émettre l'état Loading pour afficher le spinner
      emit(AudioLoading());

      try {
        // 2. Appel à l'API via le repository
        final audios = await repository.getAudios();

        // 3. Si succès, émettre l'état Loaded avec les audios
        emit(AudioLoaded(audios));
      } catch (e) {
        // 4. Si erreur, émettre l'état Error avec le message
        emit(AudioError(e.toString()));
      }
    });
  }
}
