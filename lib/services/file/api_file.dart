import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:safesync/models/user/user.dart';

class ApiFile {
  static const String url = 'api-drivehub-production.up.railway.app';
  User user = Get.find();

  Future<Map<String, dynamic>> shareFile(
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
        return data["response"];
      }

      return {"Error": 'Error al compartir.'};
    } catch (e) {
      return {"Error": 'Error Desconocido'};
    }
  }

  Future<Map<String, dynamic>> uploadFile(
      {required String fileName,
      required String folderName,
      required String filePath,
      String? token}) async {
    var dioInstance = dio.Dio();
    var formData = dio.FormData.fromMap({
      "gallery": await dio.MultipartFile.fromFile(filePath, filename: fileName),
    });
    try {
      final response = await dioInstance.put(
        Uri.https(url,
                '/api/users/addFields/${user.user}/$folderName/Default${user.user}')
            .toString(),
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      Map<String, dynamic> data = response.data;

      if (data.containsKey("userFileUpdate")) {
        return data["userFileUpdate"];
      }

      return {'Error': 'Error al subir'};
    } catch (e) {
      return {'Error': 'Error desconocido'};
    }
  }

  Future<Map<String, dynamic>> deleteFile(
      {required List<String> fileName,
      required String folderName,
      String? token}) async {
    try {
      final response = await http.delete(
          Uri.https(url, '/api/users/deletefiles/${user.user}/$folderName'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({"files": fileName}));

      Map<String, dynamic> data = json.decode(response.body);

      print(data);

      if (data.containsKey("userFileDeletes")) {
        return data["userFileDeletes"];
      }

      return {'Error': 'Error al eliminar'};
    } catch (e) {
      return {'Error': 'Error desconocido'};
    }
  }
}
