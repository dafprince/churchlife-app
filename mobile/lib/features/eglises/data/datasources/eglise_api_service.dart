import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/core/api_constants.dart';
import 'package:mobile/features/eglises/data/models/eglise_model.dart';

class EgliseApiService {
  Future<List<EgliseModel>> getEglises() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/eglises'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => EgliseModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur serveur : ${response.statusCode}');
    }
  }
}
