import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/containers/upload_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class FilesPage extends StatelessWidget {
  final Function(Color) setColor;
  FilesPage(this.setColor, {super.key});

  TextEditingController controller = TextEditingController();
  Widget uploadForm = const SizedBox();
  var seeOptions = false.obs;
  var upload = false.obs;
  String folderName = "";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          PagesContainer(
              content: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  titleLabel("Archivos", fontSize: 24),
                  const Spacer(),
                  const Icon(Icons.filter_alt_outlined,
                      color: Color.fromRGBO(122, 133, 159, 1), size: 25),
                  const SizedBox(width: 10),
                  const Icon(Icons.sort_rounded,
                      color: Color.fromRGBO(122, 133, 159, 1), size: 25)
                ],
              ),
              const SizedBox(height: 15),
              SearchInput(controller: controller),
              const SizedBox(height: 15),
              // card movible (proximamente)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blueGrey.shade200,
                            blurRadius: 10,
                            offset: const Offset(5, 5))
                      ]),
                  child: Row(children: [
                    Icon(Icons.folder_rounded,
                        color: Colors.red.shade500, size: 74),
                    const SizedBox(width: 5),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Programación Móvil",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(65, 86, 110, 1))),
                        SizedBox(height: 4),
                        Text(
                          "4.6 MB",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(115, 133, 161, 1)),
                        )
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz,
                        size: 30, color: Color.fromRGBO(52, 86, 119, 1)),
                    const SizedBox(width: 6)
                  ]))
            ],
          )),
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
                              setColor(const Color.fromARGB(255, 82, 114, 143));
                              uploadForm = uploadContainer(
                                  title: "Crear carpeta",
                                  onClose: () {
                                    setColor(
                                        const Color.fromRGBO(177, 224, 255, 1));
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
                                "Archivo", () async {
                              Map<String, String> fileData =
                                  await obtenerArchivo();
                              if (!fileData.containsKey("canceled")) {
                                setColor(
                                    const Color.fromARGB(255, 82, 114, 143));
                                uploadForm = uploadContainer(
                                    title: "Subir archivo",
                                    folderName: folderName,
                                    fileData: fileData,
                                    onClose: () {
                                      setColor(const Color.fromRGBO(
                                          177, 224, 255, 1));
                                      uploadForm = const SizedBox();
                                      upload.value = false;
                                    });

                                upload.value = true;
                              }
                              seeOptions.value = false;
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
