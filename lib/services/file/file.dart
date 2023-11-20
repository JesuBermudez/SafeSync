import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/file/api_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> downloadFile(
    String url, String filename, Function(String) setPath) async {
  final directory = await getExternalStorageDirectory();
  if (directory == null) {
    return "";
  }
  var filePath = '${directory.path}/$filename';
  var file = File(filePath);

  if (!file.existsSync()) {
    // Descargar el archivo
    try {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      showDialog(
          context: Get.context!,
          builder: (_) => AlertDialog(
                title: const Text("Error"),
                content: Text('Error al abrir el archivo: $filename'),
              ));
    }
  }

  setPath(filePath);

  return filePath;
}

void openFile(String pathToFile) async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    final result = await OpenFile.open(pathToFile);

    if (result.type != ResultType.done) {
      showDialog(
          context: Get.context!,
          builder: (_) => AlertDialog(
                title: Text(pathToFile.split("/").reversed.toList()[0]),
                content: Text('Error al abrir el archivo: ${result.message}'),
              ));
    }
  }
}

Future<Map<String, String>> obtenerArchivo() async {
  FilePickerResult? resultado = await FilePicker.platform.pickFiles();

  if (resultado != null) {
    PlatformFile archivo = resultado.files.first;

    return {"name": archivo.name, "path": "${archivo.path}"};
  } else {
    return {"canceled": "canceled"};
  }
}

Future<Map<String, dynamic>> shareFile(
    String fileName, String folderName) async {
  final prefs = await SharedPreferences.getInstance();

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  final userToken = prefs.getString('userToken');

  ApiFile apiService = ApiFile();

  try {
    Map<String, dynamic> sucess = await apiService.shareFile(
        fileName: fileName, folderName: folderName, token: userToken);
    Navigator.pop(Get.context!);

    if (!sucess.containsKey("link")) {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo compartir el archivo.'),
        ),
      );
      return {};
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
    return {};
  }
}

void uploadFile(String fileName, String folderName, String filePath,
    Function(int count, {String text, Icon? icon}) onUploading) async {
  final prefs = await SharedPreferences.getInstance();
  User user = Get.find();

  onUploading(1,
      text: "Subiendo",
      icon:
          const Icon(Icons.cloud_upload_rounded, color: Colors.blue, size: 20));

  final userToken = prefs.getString('userToken');

  ApiFile apiService = ApiFile();

  try {
    Map<String, dynamic> sucess = await apiService.uploadFile(
        fileName: fileName,
        folderName: folderName,
        filePath: filePath,
        token: userToken);

    onUploading(-1);

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

void deleteFile(List<String> fileName, String folderName) async {
  final prefs = await SharedPreferences.getInstance();
  User user = Get.find();

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  final userToken = prefs.getString('userToken');

  ApiFile apiService = ApiFile();

  try {
    Map<String, dynamic> sucess = await apiService.deleteFile(
        fileName: fileName, folderName: folderName, token: userToken);

    Navigator.pop(Get.context!);

    if (sucess.containsKey("_id")) {
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: Text(
              fileName.length > 1 ? "${fileName.length} Archivos" : fileName[0],
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          content: Text(fileName.length > 1
              ? "Se eliminaron los archivos."
              : 'Se elimino el archivo.'),
        ),
      );

      user.jsonFromUser(sucess);
    } else {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo eliminar el archivo.'),
        ),
      );
    }
  } catch (e) {
    Navigator.pop(Get.context!);

    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('No se pudo eliminar el archivo.'),
      ),
    );
  }
}
