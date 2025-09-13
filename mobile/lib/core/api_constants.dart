import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    // URL de production (votre backend sur Render)
    return "https://churchlife-app-backend.onrender.com/api";

    // Code local gardé en commentaire si besoin plus tard
    // try {
    //   final result = InternetAddress.lookup('10.0.2.2');
    //   return "http://10.0.2.2:5000/api";
    // } catch (e) {
    //   return "http://192.168.1.6:5000/api";
    // }
  }
}
