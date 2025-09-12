import 'package:bloc/bloc.dart';

import 'user_event.dart';
import 'user_state.dart';
import '../data/repositories/UserRepository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    // Gestion de l'événement LoadUsersEvent
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading()); // On met l'état en "chargement"
      try {
        // On récupère les users depuis le repository
        final users = await userRepository.getUsers();
        emit(UserLoaded(users)); // Succès → on envoie les données
      } catch (e) {
        emit(UserError(e.toString())); // Erreur → on envoie le message
      }
    });
    // NOUVEAU : Gestion de l'événement de suppression
    on<DeleteUserEvent>((event, emit) async {
      try {
        // 1. On appelle le repository pour supprimer
        //    event.userId contient l'ID de l'utilisateur à supprimer
        await userRepository.deleteUser(event.userId);

        // 2. Une fois supprimé, on recharge la liste
        //    pour avoir la liste mise à jour sans l'utilisateur supprimé
        final users = await userRepository.getUsers();

        // 3. On émet le nouvel état avec la liste actualisée
        emit(UserLoaded(users));
      } catch (e) {
        // 4. Si erreur, on informe l'utilisateur
        emit(UserError("Erreur lors de la suppression: ${e.toString()}"));
      }
    });
    // NOUVEAU : Gestion de l'événement de modification
    on<UpdateUserEvent>((event, emit) async {
      try {
        emit(UserLoading());

        // On récupère l'utilisateur modifié
        final updatedUser = await userRepository.updateUser(event.updatedUser);

        // On pourrait l'utiliser pour afficher un message avec son nom
        print("Utilisateur ${updatedUser.name} modifié avec succès");

        // Ou mettre à jour la liste localement sans refaire un appel API
        final users = await userRepository.getUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Erreur lors de la modification: ${e.toString()}"));
        try {
          final users = await userRepository.getUsers();
          emit(UserLoaded(users));
        } catch (_) {}
      }
    });
    //==
    // NOUVEAU : Gestion de l'événement d'ajout
    on<AddUserEvent>((event, emit) async {
      try {
        // 1. Afficher un loader pendant la création
        emit(UserLoading());

        // 2. Appeler le repository pour créer l'utilisateur
        //    On passe les valeurs de l'événement
        final newUser = await userRepository.createUser(
          event.name,
          event.email,
          event.age,
        );

        // 3. Log pour debug (optionnel)
        print(
          "Nouvel utilisateur créé: ${newUser.name} avec ID: ${newUser.id}",
        );

        // 4. Recharger la liste complète pour inclure le nouvel utilisateur
        //    Alternative : on pourrait juste ajouter newUser à la liste locale
        final users = await userRepository.getUsers();

        // 5. Émettre le nouvel état avec la liste mise à jour
        emit(UserLoaded(users));

        // Le nouvel utilisateur apparaîtra maintenant dans la grille
      } catch (e) {
        // 6. Si erreur (email déjà existant, données invalides, etc.)
        emit(UserError("Erreur lors de l'ajout: ${e.toString()}"));

        // 7. Recharger quand même la liste pour revenir à un état stable
        try {
          final users = await userRepository.getUsers();
          emit(UserLoaded(users));
        } catch (_) {
          // Si même le rechargement échoue, on reste sur l'erreur
        }
      }
    });
  }
}
