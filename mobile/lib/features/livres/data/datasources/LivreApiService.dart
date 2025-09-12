import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/livre_model.dart';

class LivreApiService {
  // Récupérer les livres d'une catégorie spécifique
  Future<List<LivreModel>> getLivresByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/livres/category/$categoryId"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LivreModel.fromJson(json)).toList();
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion: $e");
    }
  }
}
