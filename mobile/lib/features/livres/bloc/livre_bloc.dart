import 'package:flutter_bloc/flutter_bloc.dart';
import 'livre_event.dart';
import 'livre_state.dart';
import '../data/repositories/LivreRepositorie.dart';

class LivreBloc extends Bloc<LivreEvent, LivreState> {
  final LivreRepository repository;

  LivreBloc(this.repository) : super(LivreInitial()) {
    // Gestion de l'événement LoadLivresByCategoryEvent
    on<LoadLivresByCategoryEvent>((event, emit) async {
      // 1. Émettre l'état Loading pour afficher le spinner
      emit(LivreLoading());

      try {
        // 2. Appel à l'API via le repository avec l'ID de catégorie
        final livres = await repository.getLivresByCategory(event.categoryId);

        // 3. Si succès, émettre l'état Loaded avec les livres ET le nom de catégorie
        emit(LivreLoaded(livres: livres, categoryName: event.categoryName));
      } catch (e) {
        // 4. Si erreur, émettre l'état Error avec le message
        emit(LivreError(e.toString()));
      }
    });
  }
}
