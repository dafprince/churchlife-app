// features/annonces/bloc/annonce_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'annonce_event.dart';
import 'annonce_state.dart';
import '../data/repositories/annonce_repositorie.dart';

class AnnonceBloc extends Bloc<AnnonceEvent, AnnonceState> {
  final AnnonceRepository repository;

  AnnonceBloc(this.repository) : super(AnnonceInitial()) {
    on<LoadAnnoncesEvent>((event, emit) async {
      emit(AnnonceLoading());

      try {
        final annonces = await repository.getAnnonces();
        emit(AnnonceLoaded(annonces));
      } catch (e) {
        emit(AnnonceError(e.toString()));
      }
    });
  }
}
