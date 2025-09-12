// But : écrire une fonction qui va taper l’API (GET /users) et ramener une liste de User.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/User.dart';

/// Cette classe est responsable de communiquer avec l'API Backend
/// /// pour récupérer les utilisateurs (GET /users).
class UserApiService {
  /// Méthode qui appelle l'API et retourne une liste de User
  Future<List<User>> getUsers() async {
    try {
      // 1. On fait une requête GET vers http://10.0.2.2:5000/api/users
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/users"),
      );

      // 2. Si le code est 200 => succès
      if (response.statusCode == 200) {
        // response.body = JSON (liste d'utilisateurs)
        final List<dynamic> data = json.decode(response.body);

        // 3. On convertit chaque élément JSON en un objet User
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        // Si erreur HTTP (404, 500, etc.)
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      // Si problème de connexion ou parsing JSON
      throw Exception("Erreur de connexion ou parsing: $e");
    }
  }

  //==
  /// Méthode pour supprimer un utilisateur via l'API
  ///
  /// [userId] : l'identifiant MongoDB de l'utilisateur à supprimer (_id)
  /// Ne retourne rien (void) car on fait juste une suppression
  Future<void> deleteUser(String userId) async {
    try {
      // 1. Construction de l'URL : http://10.0.2.2:5000/api/users/67abc123...
      //    On ajoute l'ID de l'utilisateur à la fin de l'URL
      final response = await http.delete(
        Uri.parse("${ApiConstants.baseUrl}/users/$userId"),
      );

      // 2. Vérification de la réponse
      //    - 200 = succès, l'utilisateur a été supprimé
      //    - Autre code = problème (404 si user non trouvé, 500 si erreur serveur)
      if (response.statusCode != 200) {
        // Si ce n'est pas 200, on lance une erreur avec le code reçu
        throw Exception(
          "Erreur lors de la suppression: ${response.statusCode}",
        );
      }

      // 3. Si on arrive ici, c'est que tout s'est bien passé
      //    On ne retourne rien car DELETE ne renvoie pas de données
    } catch (e) {
      // 4. Si problème de connexion (pas d'internet, serveur éteint, etc.)
      //    on lance une exception avec le message d'erreur
      throw Exception("Erreur de connexion: $e");
    }
  }

  /// Méthode pour modifier un utilisateur via l'API
  ///
  /// [user] : l'objet User avec les nouvelles valeurs
  /// Retourne : le User modifié depuis le backend
  ///
  /// Pourquoi retourner un User ?
  /// - Le backend peut modifier certains champs (comme updatedAt)
  /// - On veut être sûr d'avoir la version finale
  Future<User> updateUser(User user) async {
    try {
      // 1. Préparer le body de la requête en JSON
      //    toJson() va convertir notre User en Map pour l'envoyer
      final body = json.encode({
        'name': user.name,
        'email': user.email,
        'age': user.age,
        // On n'envoie pas l'_id dans le body, il est dans l'URL
      });

      // 2. Faire une requête PUT vers /users/:id
      //    PUT = modification d'une ressource existante
      final response = await http.put(
        Uri.parse("${ApiConstants.baseUrl}/users/${user.id}"),
        headers: {
          'Content-Type': 'application/json', // On dit qu'on envoie du JSON
        },
        body: body,
      );

      // 3. Vérifier la réponse
      if (response.statusCode == 200) {
        // Succès ! Le backend renvoie l'utilisateur modifié
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        // Erreur (404 si user non trouvé, 400 si données invalides)
        throw Exception(
          "Erreur lors de la modification: ${response.statusCode}",
        );
      }
    } catch (e) {
      // Problème de connexion ou autre
      throw Exception("Erreur de connexion: $e");
    }
  }

  //==
  /// Méthode pour créer un nouvel utilisateur via l'API
  ///
  /// [name], [email], [age] : les informations du nouvel utilisateur
  /// Retourne : le User créé avec son ID généré par MongoDB
  ///
  /// Pourquoi pas passer un User directement ?
  /// - Parce qu'on n'a pas encore d'ID (MongoDB le génère)
  /// - Plus clair de passer les champs séparément pour une création
  Future<User> createUser(String name, String email, int age) async {
    try {
      // 1. Préparer les données à envoyer
      //    Pas d'_id car MongoDB va le créer
      final body = json.encode({'name': name, 'email': email, 'age': age});

      // 2. Faire une requête POST vers /users
      //    POST = création d'une nouvelle ressource
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/users"),
        headers: {
          'Content-Type':
              'application/json', // Important pour que le backend comprenne
        },
        body: body,
      );

      // 3. Vérifier la réponse
      //    201 = Created (standard pour une création)
      //    200 = OK (certains backends utilisent ça)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Le backend renvoie l'utilisateur créé avec son nouvel ID
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        // Erreur (400 si données invalides, 409 si email existe déjà)
        throw Exception("Erreur lors de la création: ${response.statusCode}");
      }
    } catch (e) {
      // Problème de connexion ou autre
      throw Exception("Erreur de connexion: $e");
    }
  }
}
