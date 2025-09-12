import '../data/models/category_model.dart';

/// Classe abstraite pour tous les états liés aux catégories
abstract class CategoryState {}

/// État initial - quand on n'a encore rien fait
class CategoryInitial extends CategoryState {}

/// État de chargement - quand on fait l'appel API
class CategoryLoading extends CategoryState {}

/// État de succès - quand on a reçu les catégories
class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);
}

/// État d'erreur - quand quelque chose a mal fonctionné
class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
