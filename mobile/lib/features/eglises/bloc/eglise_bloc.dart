// features/annonces/bloc/annonce_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'eglise_event.dart';
import 'eglise_state.dart';
import '../data/repositories/eglise_repositorie.dart';

class EgliseBloc extends Bloc<EgliseEvent, EgliseState> {
  final EgliseRepository repository;

  EgliseBloc(this.repository) : super(EgliseInitial()) {
    on<LoadEglisesEvent>((event, emit) async {
      emit(EgliseLoading());

      try {
        final eglises = await repository.getEglises();
        emit(EgliseLoaded(eglises));
      } catch (e) {
        emit(EgliseError(e.toString()));
      }
    });
  }
}
