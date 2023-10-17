import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiFile {
  static const String url = 'api-drivehub-production.up.railway.app';

  Future<String> shareFile(
      {required String fileName,
      required String folderName,
      String? token}) async {
    try {
      final response = await http.get(
        Uri.https(url, '/api/files/getlink', {
          'identifier': fileName,
          'Directory': folderName,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("response")) {
        return data["response"]["link"];
      }

      return 'Error al compartir.';
    } catch (e) {
      return 'Error Desconocido';
    }
  }
}
