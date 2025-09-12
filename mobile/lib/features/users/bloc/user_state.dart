import 'package:equatable/equatable.dart';
import '.././data/models/User.dart';

// Classe abstraite de base pour tous les états
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

// État initial
class UserInitial extends UserState {}

// État pendant le chargement
class UserLoading extends UserState {}

// État quand les users sont chargés avec succès
class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

// État en cas d’erreur
class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
