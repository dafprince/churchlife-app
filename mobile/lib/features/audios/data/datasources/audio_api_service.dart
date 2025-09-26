import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api_constants.dart';
import '../models/audio_model.dart';

class AudioApiService {
  // Récupérer tous les audios (existant)
  Future<List<AudioModel>> getAudios() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/audios"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AudioModel.fromJson(json)).toList();
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
    }
  }

  // Nouvelle méthode : récupérer les audios filtrés par id d'église
  Future<List<AudioModel>> getAudiosByEglise(String egliseId) async {
    final url = "${ApiConstants.baseUrl}/audios/byEglise/$egliseId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AudioModel.fromJson(json)).toList();
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
    }
  }
}
