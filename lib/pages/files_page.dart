import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/file/map_folders.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/containers/page_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class FilesPage extends StatelessWidget {
  FilesPage({super.key});

  User user = Get.find();
  FilePageController filePageController = Get.find();

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
                  // go back button
                  if (filePageController.folderName.value != "Archivos   ") ...[
                    InkWell(
                        onTap: () =>
                            filePageController.folderName.value = "Archivos   ",
                        child: Icon(Icons.arrow_back_rounded,
                            color: Colors.blueGrey.shade900, size: 28)),
                    const SizedBox(width: 7)
                  ],
                  // tittle
                  titleLabel(filePageController.folderName.value.trim(),
                      fontSize: 24),
                  const Spacer(),
                  // filter
                  PopupMenuButton(
                      icon: const Icon(Icons.filter_alt_outlined,
                          color: Color.fromRGBO(122, 133, 159, 1), size: 25),
                      padding: EdgeInsets.zero,
                      onSelected: (value) =>
                          value != filePageController.filterOption.value
                              ? filePageController.setFilterOption(value)
                              : false,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                                value: '', child: Text("Todos")),
                            const PopupMenuItem<String>(
                                value: 'Folder', child: Text("Carpetas")),
                            const PopupMenuItem<String>(
                                value: 'Imagen', child: Text("Imagenes")),
                            const PopupMenuItem<String>(
                                value: 'Video', child: Text("Videos")),
                            const PopupMenuItem<String>(
                                value: 'Documento', child: Text("Documentos")),
                          ]),
                  const SizedBox(width: 10),
                  // order
                  InkWell(
                    onTap: () => filePageController.setOrder(),
                    child: const Icon(Icons.sort_rounded,
                        color: Color.fromRGBO(122, 133, 159, 1), size: 25),
                  )
                ],
              ),
              // search input
              const SizedBox(height: 15),
              SearchInput(
                  controller: filePageController.searchController,
                  onChanged: (value) => filePageController.setSearch(value)),
                  
              // files list
              const SizedBox(height: 15),

              FutureBuilder<List<Widget>>(
                future: mapFolders(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  // files and folders list
                  if (snapshot.hasData) {
                    return Wrap(
                      runSpacing: 7,
                      children: snapshot.data!,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),

              const SizedBox(height: 15)
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
                    if (filePageController.seeOptions.value) ...[
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
                                "Carpeta",
                                () => filePageController.onUploadFolder()),
                            simpleButton(
                                Icon(
                                  Icons.insert_drive_file_rounded,
                                  color: Colors.blueGrey.shade700,
                                ),
                                "Archivo",
                                () => filePageController.onUploadFile())
                          ],
                        ),
                      ),
                    ],
                    uploadFileButton(
                        onTap: () => filePageController.setSeeOptions(
                            !filePageController.seeOptions.value))
                  ],
                ),
              )),
          filePageController.getUploadForm(),
          filePageController.getFileOpen()
        ],
      ),
    );
  }
}
