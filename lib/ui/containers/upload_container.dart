import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/directory/directory.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/labels/title_label.dart';
import 'package:path/path.dart' as path;

Widget uploadContainer(
    {required String title,
    String? folderName,
    Map? fileData,
    Function(int count, {String text, Icon? icon})? onUploading,
    required VoidCallback onClose}) {
  User user = Get.find();
  TextEditingController controller = TextEditingController(
      text: fileData != null
          ? path.basenameWithoutExtension(fileData["name"])
          : null);
  String filePath = fileData != null ? fileData["path"] : "";
  String extension = path.extension(fileData != null ? fileData["name"] : "");

  return Stack(children: [
    GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    ),
    // AppBar
    Positioned(
      top: 0,
      child: uploadAppBar(title, onClose),
    ),
    Container(
        width: Get.width,
        height: Get.height,
        alignment: Alignment.center,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            width: 240,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  subtitleLabel("Nombre"),
                  const SizedBox(height: 10),
                  // input
                  getInput(title, controller, extension),
                  const SizedBox(height: 10),
                  // Boton
                  SizedBox(
                      width: double.infinity,
                      child: sendButton(
                          icon: title == "Subir archivo"
                              ? const Icon(Icons.upload_rounded, size: 26)
                              : const Icon(Icons.create_new_folder_rounded,
                                  size: 26),
                          text: title.split(" ")[0],
                          send: () {
                            if (title == "Subir archivo") {
                              uploadFile(
                                  '${controller.text.trim()}$extension',
                                  folderName == ""
                                      ? "Default${user.user}"
                                      : folderName!,
                                  filePath,
                                  onUploading!);
                            } else {
                              directory(controller.text.trim());
                            }

                            onClose();
                          }))
                ])))
  ]);
}

Widget getInput(String type, TextEditingController controller,
    [String? extension]) {
  if (type == "Crear carpeta") {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "ej: Documentos",
          hintStyle: TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
    );
  } else {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          suffixText: extension,
          suffixStyle: const TextStyle(
              color: Color.fromRGBO(176, 199, 212, 1),
              fontWeight: FontWeight.w500,
              fontSize: 16),
          hintText: "ej: Archivo",
          hintStyle: const TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
    );
  }
}
