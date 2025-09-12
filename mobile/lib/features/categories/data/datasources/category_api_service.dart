import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/category_model.dart';

/// Cette classe est responsable de communiquer avec l'API Backend
/// pour récupérer les catégories (GET /categories).
class CategoryApiService {
  /// Méthode qui appelle l'API et retourne une liste de Category
  Future<List<CategoryModel>> getCategories() async {
    try {
      // 1. On fait une requête GET vers http://10.0.2.2:5000/api/categories
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/categories"),
      );

      // 2. Si le code est 200 => succès
      if (response.statusCode == 200) {
        // response.body = JSON (liste de catégories)
        final List<dynamic> data = json.decode(response.body);

        // 3. On convertit chaque élément JSON en un objet CategoryModel
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        // Si erreur HTTP (404, 500, etc.)
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      // Si problème de connexion ou parsing JSON
      throw Exception("Erreur de connexion ou parsing: $e");
    }
  }
}
