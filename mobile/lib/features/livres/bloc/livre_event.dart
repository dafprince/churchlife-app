/// Classe abstraite pour tous les événements liés aux livres
abstract class LivreEvent {}

/// Événement pour charger les livres d'une catégorie spécifique
class LoadLivresByCategoryEvent extends LivreEvent {
  final String categoryId;
  final String categoryName; // Pour afficher le nom dans le titre

  LoadLivresByCategoryEvent({
    required this.categoryId,
    required this.categoryName,
  });
}
