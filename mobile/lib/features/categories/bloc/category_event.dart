/// Classe abstraite pour tous les événements liés aux catégories
abstract class CategoryEvent {}

/// Événement pour charger toutes les catégories depuis l'API
class LoadCategoriesEvent extends CategoryEvent {}
