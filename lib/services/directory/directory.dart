import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/services/directory/api_directory.dart';
import 'package:safesync/services/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void directory(String folderName) async {
  final prefs = await SharedPreferences.getInstance();

  if (folderName == '') {
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Atención'),
        content: Text('Por favor, no deje campos vacíos.'),
      ),
    );
    return;
  }

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  final userToken = prefs.getString('userToken');

  ApiDirectory apiService = ApiDirectory();

  try {
    String sucess = await apiService.createDirectory(
        folderName: folderName, token: userToken);
    Navigator.pop(Get.context!);
    if (sucess == 'Ok') {
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: const Text('Creado'),
          content: Text('Se creo la carpeta: "$folderName"'),
        ),
      );

      getUser();
    } else {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo crear la carpeta'),
        ),
      );
    }
  } catch (e) {
    Navigator.pop(Get.context!);
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('No se pudo crear la carpeta'),
      ),
    );
  }
}
