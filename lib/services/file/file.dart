import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/file/api_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> shareFile(String fileName, String folderName) async {
  final prefs = await SharedPreferences.getInstance();

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  final userToken = prefs.getString('userToken');

  ApiFile apiService = ApiFile();

  try {
    String sucess = await apiService.shareFile(
        fileName: fileName, folderName: folderName, token: userToken);
    Navigator.pop(Get.context!);

    if (sucess == 'Error al compartir.') {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo compartir el archivo.'),
        ),
      );
      return "";
    }

    return sucess;
  } catch (e) {
    Navigator.pop(Get.context!);
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('No se pudo compartir el archivo.'),
      ),
    );
    return "";
  }
}

void uploadFile(String fileName, String folderName, String filePath) async {
  final prefs = await SharedPreferences.getInstance();
  User user = Get.find();

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  final userToken = prefs.getString('userToken');

  ApiFile apiService = ApiFile();

  try {
    Map<String, dynamic> sucess = await apiService.uploadFile(
        fileName: fileName,
        folderName: folderName,
        filePath: filePath,
        token: userToken);
    Navigator.pop(Get.context!);

    if (sucess.containsKey("_id")) {
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: const Text('Se subio el archivo.'),
        ),
      );

      user.jsonFromUser(sucess);
    } else {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo subir el archivo.'),
        ),
      );
    }
  } catch (e) {
    Navigator.pop(Get.context!);
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('No se pudo subir el archivo.'),
      ),
    );
  }
}
