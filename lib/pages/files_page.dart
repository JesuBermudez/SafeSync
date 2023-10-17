import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/containers/upload_container.dart';

// ignore: must_be_immutable
class FilesPage extends StatelessWidget {
  FilesPage({super.key});

  Widget uploadForm = const SizedBox();
  var seeOptions = false.obs;
  var upload = false.obs;
  String folderName = "";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          PagesContainer(content: Container()),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (seeOptions.value) ...[
                      SizedBox(
                        height: 100,
                        width: 110,
                        child: Column(
                          children: [
                            simpleButton(
                                Icon(
                                  Icons.folder,
                                  color: Colors.blueGrey.shade700,
                                ),
                                "Carpeta", () {
                              uploadForm = uploadContainer(
                                  title: "Crear carpeta",
                                  onClose: () {
                                    uploadForm = const SizedBox();
                                    upload.value = false;
                                  });
                              seeOptions.value = false;
                              upload.value = true;
                            }),
                            simpleButton(
                                Icon(
                                  Icons.insert_drive_file_rounded,
                                  color: Colors.blueGrey.shade700,
                                ),
                                "Archivo", () {
                              uploadForm = uploadContainer(
                                  title: "Subir archivo",
                                  folderName: folderName,
                                  onClose: () {
                                    uploadForm = const SizedBox();
                                    upload.value = false;
                                  });
                              seeOptions.value = false;
                              upload.value = true;
                            })
                          ],
                        ),
                      ),
                    ],
                    uploadFileButton(
                        onTap: () => seeOptions.value = !seeOptions.value)
                  ],
                ),
              )),
          upload.value ? uploadForm : const SizedBox()
        ],
      ),
    );
  }
}
