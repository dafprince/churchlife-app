import '../datasources/UserApiService.dart';
import '../models/User.dart';

class UserRepository {
  final UserApiService apiService;

  UserRepository(this.apiService);

  Future<List<User>> getUsers() async {
    try {
      return await apiService.getUsers();
    } catch (e) {
      throw Exception("Impossible de récupérer les utilisateurs: $e");
    }
  }

  /// Méthode pour supprimer un utilisateur
  ///
  /// Cette méthode fait le lien entre le BLoC et l'API
  /// [userId] : l'ID de l'utilisateur à supprimer
  ///
  /// Pourquoi passer par le Repository ?
  /// - Pour séparer la logique métier (BLoC) de l'accès aux données (API)
  /// - Plus tard, on pourrait ajouter du cache ou d'autres vérifications ici
  Future<void> deleteUser(String userId) async {
    try {
      // 1. On appelle la méthode deleteUser de l'API Service
      await apiService.deleteUser(userId);

      // 2. Si tout va bien, la méthode se termine normalement
      //    Le BLoC saura que la suppression a réussi
    } catch (e) {
      // 3. Si l'API lance une erreur, on la transforme en message plus clair
      //    pour l'utilisateur final
      throw Exception("Impossible de supprimer l'utilisateur: $e");
    }
  }

  /// Méthode pour modifier un utilisateur
  ///
  /// [user] : l'utilisateur avec les nouvelles valeurs
  /// Retourne : l'utilisateur modifié depuis le backend
  ///
  /// Le Repository fait le pont entre BLoC et API
  /// Plus tard, on pourrait ajouter ici :
  /// - Mise à jour du cache local
  /// - Validation des données
  /// - Gestion offline
  Future<User> updateUser(User user) async {
    try {
      // 1. Validation basique : on vérifie qu'on a bien un ID
      //    Sans ID, impossible de modifier
      if (user.id.isEmpty) {
        throw Exception("ID utilisateur manquant pour la modification");
      }

      // 2. Appel de l'API pour modifier
      final updatedUser = await apiService.updateUser(user);

      // 3. On retourne l'utilisateur modifié
      //    Le BLoC pourra mettre à jour la liste
      return updatedUser;
    } catch (e) {
      // 4. Si erreur, on la transforme en message plus clair
      throw Exception("Impossible de modifier l'utilisateur: $e");
    }
  }

  //==
  /// Méthode pour créer un nouvel utilisateur
  ///
  /// [name], [email], [age] : les informations du nouvel utilisateur
  /// Retourne : l'utilisateur créé avec son ID depuis le backend
  ///
  /// Validations basiques avant envoi à l'API
  /// Plus tard on pourrait ajouter :
  /// - Vérification d'unicité de l'email en local
  /// - Sauvegarde en cache local
  /// - Mode offline avec synchronisation
  Future<User> createUser(String name, String email, int age) async {
    try {
      // 1. Validations basiques avant d'appeler l'API
      //    trim() enlève les espaces avant/après
      if (name.trim().isEmpty) {
        throw Exception("Le nom ne peut pas être vide");
      }

      if (email.trim().isEmpty || !email.contains('@')) {
        throw Exception("Email invalide");
      }

      if (age < 1 || age > 120) {
        throw Exception("L'âge doit être entre 1 et 120");
      }

      // 2. Appel de l'API pour créer l'utilisateur
      //    L'API retourne l'utilisateur avec son ID généré
      final newUser = await apiService.createUser(
        name.trim(),
        email.trim(),
        age,
      );

      // 3. On retourne l'utilisateur créé
      //    Le BLoC pourra l'ajouter à la liste
      return newUser;
    } catch (e) {
      // 4. Si erreur, message plus clair pour l'utilisateur
      throw Exception("Impossible de créer l'utilisateur: $e");
    }
  }
}
