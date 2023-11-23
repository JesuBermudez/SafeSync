import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:safesync/models/user/user.dart';

class ApiService {
  static const String apiUrl =
      'https://api-drivehub-production.up.railway.app/api/auth/login';

  Future<Map<String, dynamic>> login() async {
    User user = Get.find();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJsonForLogin()),
      );

      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('userEmailCorrect')) {
        return data;
      }

      return data.containsKey('error')
          ? {'Error': data['error']}
          : {'Error': 'Error al iniciar sesión'};
    } catch (e) {
      return {'Error': '$e'};
    }
  }
}
