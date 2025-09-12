import '../data/models/livre_model.dart';

/// Classe abstraite pour tous les états liés aux livres
abstract class LivreState {}

/// État initial - quand on n'a encore rien fait
class LivreInitial extends LivreState {}

/// État de chargement - quand on fait l'appel API
class LivreLoading extends LivreState {}

/// État de succès - quand on a reçu les livres
class LivreLoaded extends LivreState {
  final List<LivreModel> livres;
  final String categoryName; // Nom de la catégorie pour l'affichage

  LivreLoaded({required this.livres, required this.categoryName});
}

/// État d'erreur - quand quelque chose a mal fonctionné
class LivreError extends LivreState {
  final String message;

  LivreError(this.message);
}
