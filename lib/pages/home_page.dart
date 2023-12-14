import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/icons/icons.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/cards/card_file_category.dart';
import 'package:safesync/ui/containers/page_container.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  User user = Get.find();
  FileController fileController = Get.find();
  FilePageController filePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final cardSpace = (Get.width - (Get.width * 0.08)) - 10;
    final spacing =
        (cardSpace - (150 * (cardSpace ~/ 150))) / ((cardSpace ~/ 150) - 1);
    return Obx(() {
      return Stack(
        children: [
          PagesContainer(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleLabel("Almacenamiento"),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fileCategory(
                                  const Icon(SafeSyncIcons.foursquares,
                                      color: Colors.white, size: 80),
                                  const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  "Todo",
                                  () => filePageController.setFilterOption('')),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.folder,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Carpetas",
                                  () => filePageController.setFilterOption('Folder'),
                                  Colors.red.shade500),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.image_rounded,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Imagenes",
                                  () => filePageController.setFilterOption('Imagen'),
                                  const Color.fromARGB(255, 228, 75, 255)),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Videos",
                                  () => filePageController.setFilterOption('Video'),
                                  Colors.cyan.shade300),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.description,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Archivos",
                                  () => filePageController.setFilterOption('Documento'),
                                  Colors.greenAccent[400]),
                            ],
                          )),
                      const SizedBox(height: 30),
                      Row(children: [
                        titleLabel("Reciente"),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_downward_rounded,
                            color: Color.fromRGBO(0, 81, 151, 1))
                      ]),
                      const SizedBox(height: 15),
                      FutureBuilder<List<Widget>>(
                        future: fileController.getRecentFilesWidgets(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Widget>> snapshot) {
                          if (snapshot.hasData) {
                            return Wrap(
                                runSpacing: spacing,
                                spacing: spacing,
                                children: snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          // Por defecto, muestra un loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                      const SizedBox(height: 15)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // displays the file if one selected
          fileController.getFileOpen()
        ],
      );
    });
  }
}
