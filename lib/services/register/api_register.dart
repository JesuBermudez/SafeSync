import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/user/user.dart';

class ApiService {
  static const String apiUrl = 'http://localhost:4000/api/users/create';

  Future<String> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );
      if (response.statusCode == 201) {
        return 'OK';
      } else if (response.statusCode == 400) {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        return errorResponse['error'] ?? 'Erorr desconocido';
      } else {
        return 'Error Desconocido';
      }
    } catch (e) {
      return 'Error al registar';
    }
  }
}
