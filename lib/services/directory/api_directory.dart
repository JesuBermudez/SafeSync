import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:safesync/models/user/user.dart';

class ApiSupport {
  static const String url =
      'https://api-drivehub-production.up.railway.app/api/users/createDirectory';

  Future<String> createDirectory(
      {required String folderName, String? token}) async {
    User user = Get.find<User>();
    try {
      final response = await http.put(
        Uri.parse('$url/${user.user}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({"nameDirectory": folderName}),
      );

      if (response.statusCode == 200) {
        return "Ok";
      }

      if (response.statusCode == 500) {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        return errorResponse['msg'] ?? 'Error al crear la carpeta.';
      }
      return 'Error Desconocido';
    } catch (e) {
      return 'Error Desconocido';
    }
  }
}