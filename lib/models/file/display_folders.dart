import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safesync/models/app/app_controller.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/user/directory.dart';
import 'package:safesync/models/user/file.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/directory/directory.dart';
import 'package:safesync/services/file/file.dart';

Future<List<Widget>> displayFolder(String directory,
    {bool showFiles = false}) async {
  User user = Get.find();
  FileController fileController = Get.find();
  FilePageController filePageController = Get.find();
  AppController appController = Get.find();
  String apiPath =
      'https://api-drivehub-production.up.railway.app/api/files/unidad';
  Directories folder =
      user.directories.firstWhere((dir) => dir.nameDirectory == directory);

  if (showFiles) {
    List<Widget> files = [];
    List<Files> folderFiles = folder.files;
    folderFiles.sort((a, b) => filePageController.descOrder.value
        ? a.nameFile.toLowerCase().compareTo(b.nameFile.toLowerCase())
        : b.nameFile.toLowerCase().compareTo(a.nameFile.toLowerCase()));

    for (var file in folderFiles) {
      if (filePageController.filterOption.value != "" &&
              filePageController.filterOption.value !=
                  filePageController.typeKey(file.nameFile) ||
          !file.nameFile
              .toLowerCase()
              .contains(filePageController.searchValue.value.trim())) {
        continue;
      }

      final filePath =
          Uri.parse('$apiPath/${user.userName}/$directory/${file.nameFile}')
              .toString();

      final directoryLocal = await getApplicationDocumentsDirectory();

      final imagePreview =
          '${directoryLocal.path}/${file.nameFile.split('.').sublist(0, file.nameFile.split('.').length - 1).join('.')}.png';

      final isImage = filePageController.isImageFile(file.nameFile);
      final isVideo = filePageController.isVideoFile(file.nameFile);
      final iconCard =
          isImage ? iconImage : (isVideo ? iconVideo : iconDocument);

      files.add(InkWell(
        onTap: () {
          filePageController.setFileSelected(file, filePath, directory,
              iconCard, imagePreview, isImage, isVideo);
          FocusScope.of(Get.context!).requestFocus(FocusNode());
          appController
              .setScaffoldBackground(const Color.fromARGB(255, 82, 114, 143));
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 7,
                      offset: const Offset(5, 5))
                ]),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:
                            fileType[filePageController.typeKey(file.nameFile)]
                                ['Color'],
                        borderRadius: BorderRadius.circular(5)),
                    child: fileType[filePageController.typeKey(file.nameFile)]
                        ['Icon']),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(file.nameFile,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Color.fromRGBO(65, 86, 110, 1))),
                    const SizedBox(height: 8),
                    Text(
                      filePageController.formatFileSize(file.size),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(115, 133, 161, 1)),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color.fromRGBO(54, 93, 125, 1),
                  ),
                  onSelected: (String result) async {
                    switch (result) {
                      case 'Abrir con':
                        fileController.openWith(
                            filePageController.selectedFile!.filePath,
                            filePageController.selectedFile!.file!.nameFile);
                        break;
                      case 'Compartir link':
                        fileController.shareLink(
                            filePageController.selectedFile!.file!.nameFile,
                            filePageController.selectedFile!.folderName);
                        break;
                      case 'Mostrar QR':
                        fileController.showQR(
                            filePageController.selectedFile!.file!.nameFile,
                            filePageController.selectedFile!.folderName);
                        break;
                      case 'Borrar':
                        deleteFile([file.nameFile], directory);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        value: 'Abrir con', child: Text('Abrir con')),
                    const PopupMenuItem<String>(
                        value: 'Compartir link', child: Text('Compartir link')),
                    const PopupMenuItem(
                        value: 'Mostrar QR', child: Text('Mostrar QR')),
                    const PopupMenuItem<String>(
                        value: 'Borrar', child: Text('Borrar')),
                  ],
                ),
              ),
            ])),
      ));
    }

    return files;
  } else {
    // ignore: invalid_use_of_protected_member
    double totalSize = folder.files
        .fold(0, (previousValue, file) => previousValue + file.size);
    return [
      InkWell(
        onTap: () => filePageController.setFolderName(directory),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 7,
                      offset: const Offset(5, 5))
                ]),
            child: Row(children: [
              Icon(Icons.folder_rounded, color: Colors.red.shade500, size: 68),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(directory,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Color.fromRGBO(65, 86, 110, 1))),
                    const SizedBox(height: 8),
                    Text(
                      filePageController.formatFileSize(totalSize),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(115, 133, 161, 1)),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color.fromRGBO(54, 93, 125, 1),
                    ),
                    onSelected: (value) {
                      if (value == "Borrar") {
                        deleteDirectory(directory);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                              value: "Borrar", child: Text("Borrar"))
                        ]),
              ),
            ])),
      )
    ];
  }
}

const iconImage = Icon(Icons.image_rounded,
    size: 89, color: Color.fromARGB(255, 228, 75, 255));
final iconVideo =
    Icon(Icons.play_arrow_rounded, size: 89, color: Colors.red.shade500);
const iconDocument = Icon(Icons.description, size: 89, color: Colors.blue);

Map<String, dynamic> fileType = {
  'Imagen': {
    'Color': const Color.fromRGBO(222, 94, 221, 1),
    'Icon': const Icon(Icons.image_rounded, color: Colors.white, size: 33)
  },
  'Video': {
    'Color': Colors.cyan.shade300,
    'Icon': const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 33)
  },
  'Documento': {
    'Color': const Color.fromRGBO(92, 223, 129, 1),
    'Icon': const Icon(Icons.insert_drive_file_rounded,
        color: Colors.white, size: 33)
  }
};
