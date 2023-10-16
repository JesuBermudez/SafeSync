import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:safesync/models/support/support.dart';

class ApiSupport {
  static const String url =
      'https://api-drivehub-production.up.railway.app/api/support/sendEmail';

  Future<String> supportEmail() async {
    Support support = Get.find<Support>();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(support.toJsonSupport()),
      );
      if (response.statusCode == 200) {
        return "Email sent successfully";
      }

      if (response.statusCode == 500) {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        return errorResponse['msg'] ?? 'Error al enviar el correo';
      }
      return 'Error Desconocido';
    } catch (e) {
      return 'Error Desconocido';
    }
  }
}
