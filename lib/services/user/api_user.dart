import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://safesync.fly.dev/api/users';

  Future<Map<String, dynamic>> getUser(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('user')) {
        return data['user'];
      }

      print(data);

      return {'Error': 'Error'};
    } catch (e) {
      return {'Error': 'Error'};
    }
  }
}
