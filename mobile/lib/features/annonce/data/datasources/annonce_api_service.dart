// features/annonces/data/datasources/annonce_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/annonce_model.dart';

class AnnonceApiService {
  /// Récupère toutes les annonces depuis le backend
  Future<List<AnnonceModel>> getAnnonces() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/annonces"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AnnonceModel.fromJson(json)).toList();
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion: $e");
    }
  }
}
