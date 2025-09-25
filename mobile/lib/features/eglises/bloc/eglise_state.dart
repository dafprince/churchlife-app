// features/annonces/bloc/annonce_state.dart
import '../data/models/eglise_model.dart';

abstract class EgliseState {}

class EgliseInitial extends EgliseState {}

class EgliseLoading extends EgliseState {}

class EgliseLoaded extends EgliseState {
  final List<EgliseModel> eglises;
  EgliseLoaded(this.eglises);
}

class EgliseError extends EgliseState {
  final String message;
  EgliseError(this.message);
}
