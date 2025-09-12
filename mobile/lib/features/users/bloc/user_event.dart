import 'package:equatable/equatable.dart';
import '../data/models/User.dart';

// Classe abstraite de base pour tous les événements
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Événement pour charger les utilisateurs
class LoadUsersEvent extends UserEvent {}

/// Événement pour supprimer un utilisateur
///
/// Cet événement sera déclenché quand l'utilisateur clique sur "Supprimer"
class DeleteUserEvent extends UserEvent {
  // L'ID de l'utilisateur à supprimer
  final String userId;

  // Constructeur : on doit obligatoirement fournir un userId
  DeleteUserEvent(this.userId);

  // Pour Equatable : permet de comparer deux événements
  // (utile pour éviter de traiter deux fois le même événement)
  @override
  List<Object?> get props => [userId];
}

/// Événement pour modifier un utilisateur
///
/// Cet événement sera déclenché quand l'utilisateur valide le formulaire de modification
class UpdateUserEvent extends UserEvent {
  // L'utilisateur avec les nouvelles valeurs
  final User updatedUser;

  // Constructeur : on passe l'utilisateur modifié
  UpdateUserEvent(this.updatedUser);

  // Pour Equatable : permet de comparer deux événements
  @override
  List<Object?> get props => [updatedUser];
}

// ===
/// Événement pour ajouter un nouvel utilisateur
///
/// Cet événement sera déclenché depuis le formulaire d'ajout
/// On passe directement les valeurs, pas un User (car pas encore d'ID)
class AddUserEvent extends UserEvent {
  // Les informations du nouvel utilisateur
  final String name;
  final String email;
  final int age;

  // Constructeur : on doit fournir tous les champs
  AddUserEvent({required this.name, required this.email, required this.age});

  // Pour Equatable : permet de comparer deux événements
  @override
  List<Object?> get props => [name, email, age];
}
