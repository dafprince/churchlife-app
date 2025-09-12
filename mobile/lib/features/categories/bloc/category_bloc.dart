import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../data/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    // Quand on reçoit l'événement LoadCategoriesEvent
    on<LoadCategoriesEvent>((event, emit) async {
      // 1. On émet l'état Loading (pour afficher le spinner)
      emit(CategoryLoading());

      try {
        // 2. On appelle le repository pour récupérer les catégories
        final categories = await repository.getCategories();

        // 3. Si succès, on émet l'état Loaded avec les données
        emit(CategoryLoaded(categories));
      } catch (e) {
        // 4. Si erreur, on émet l'état Error avec le message
        emit(CategoryError(e.toString()));
      }
    });
  }
}
