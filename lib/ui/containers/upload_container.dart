import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/directory/directory.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/labels/title_label.dart';

Widget uploadContainer(
    {required String title,
    String? folderName,
    required VoidCallback onClose}) {
  TextEditingController controller = TextEditingController(text: null);
  String filePath = "";
  User user = Get.find();

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
                  title == "Subir archivo"
                      ? FutureBuilder(
                          future: obtenerArchivo(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, String>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError || snapshot.data == null) {
                                onClose();
                                return const SizedBox();
                              } else {
                                controller.text = snapshot.data!["name"] ?? "";
                                filePath = snapshot.data!["path"] ?? "";
                                print(filePath);
                                return getInput(title, controller);
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )
                      : getInput(title, controller),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child: sendButton(
                          icon: const Icon(Icons.upload_rounded, size: 26),
                          text: title.split(" ")[0],
                          send: () {
                            title == "Subir archivo"
                                ? uploadFile(
                                    controller.text,
                                    folderName == ""
                                        ? "Default${user.user}"
                                        : folderName!,
                                    filePath)
                                : directory(controller.text);
                            onClose();
                          }))
                ])))
  ]);
}

Widget getInput(String type, TextEditingController controller) {
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
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "ej: Archivo",
          hintStyle: TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
    );
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
