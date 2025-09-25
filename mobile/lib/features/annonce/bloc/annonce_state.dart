// features/annonces/bloc/annonce_state.dart
import '../data/models/annonce_model.dart';

abstract class AnnonceState {}

class AnnonceInitial extends AnnonceState {}

class AnnonceLoading extends AnnonceState {}

class AnnonceLoaded extends AnnonceState {
  final List<AnnonceModel> annonces;
  AnnonceLoaded(this.annonces);
}

class AnnonceError extends AnnonceState {
  final String message;
  AnnonceError(this.message);
}
