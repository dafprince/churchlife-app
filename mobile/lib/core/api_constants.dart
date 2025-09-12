import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    // Détection basée sur l'adresse IP locale
    try {
      // Si on peut résoudre 10.0.2.2, on est sur émulateur
      final result = InternetAddress.lookup('10.0.2.2');
      return "http://10.0.2.2:5000/api";
    } catch (e) {
      // Sinon, on est sur téléphone physique
      return "http://192.168.1.6:5000/api";
    }
  }
}
