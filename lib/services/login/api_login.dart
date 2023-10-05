import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:safesync/models/user/user.dart';

class ApiService {
  static const String apiUrl = 'http://localhost:4000/api/auth/login';

  Future<String> login() async {
    User user = Get.find();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJsonForLogin()),
      );

      if (response.statusCode == 201) {
        print(response.body);
        return 'OK';
      }
      if (response.statusCode == 400) {
        Map<String, dynamic> errorResponse = json.decode(response.body);

        return errorResponse['erro'] ?? 'Erorr desconocido';
      }

      return 'Error Desconocido';
    } catch (e) {
      return 'Error al iniciar sesión';
    }
  }
}
