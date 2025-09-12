import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/audio_model.dart';

class AudioApiService {
  /// Récupérer tous les audios depuis le backend
  Future<List<AudioModel>> getAudios() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/audios"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AudioModel.fromJson(json)).toList();
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion ou parsing: $e");
    }
  }
}
