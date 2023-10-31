import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/directory/directory.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/containers/file_open_container.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/containers/upload_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class FilesPage extends StatelessWidget {
  final Function(Color) setColor;
  FilesPage(this.setColor, this.filterOption, {super.key});

  User user = Get.find();

  TextEditingController searchController = TextEditingController();
  Widget uploadForm = const SizedBox();
  var seeOptions = false.obs;
  var upload = false.obs;
  var folderName = Rx<String>("Archivos");
  var isShowingFileWidget = false.obs;
  var selectedFile = {}.obs;
  var filterOption = "".obs;
  var descOrder = true.obs;
  String localPath = "";

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
                  if (folderName.value != "Archivos") ...[
                    GestureDetector(
                        onTap: () => folderName.value = "Archivos",
                        child: Icon(Icons.arrow_back_rounded,
                            color: Colors.blueGrey.shade900, size: 28)),
                    const SizedBox(width: 7)
                  ],
                  titleLabel(folderName.value, fontSize: 24),
                  const Spacer(),
                  PopupMenuButton(
                      icon: const Icon(Icons.filter_alt_outlined,
                          color: Color.fromRGBO(122, 133, 159, 1), size: 25),
                      padding: EdgeInsets.zero,
                      onSelected: (value) => value != filterOption.value
                          ? filterOption.value = value
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
                  GestureDetector(
                    onTap: () => descOrder.toggle(),
                    child: const Icon(Icons.sort_rounded,
                        color: Color.fromRGBO(122, 133, 159, 1), size: 25),
                  )
                ],
              ),
              const SizedBox(height: 15),
              SearchInput(controller: searchController),
              const SizedBox(height: 15),
              FutureBuilder<List<Widget>>(
                future: mapUserFolders((file) {
                  selectedFile.value = file;
                  isShowingFileWidget.value = true;
                  setColor(const Color.fromARGB(255, 82, 114, 143));
                }, (path) async {
                  if (localPath != path) {
                    final File file = File(localPath);
                    if (await file.exists()) {
                      await file.delete();
                    }
                  }
                  localPath = path;
                }, filterOption.value, descOrder.value),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
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
              )
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
                                    folderName: folderName.value == 'Archivos'
                                        ? ''
                                        : folderName.value,
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
          upload.value ? uploadForm : const SizedBox(),
          isShowingFileWidget.value
              ? FileOpen(
                  // ignore: invalid_use_of_protected_member
                  file: selectedFile.value,
                  onClose: () {
                    isShowingFileWidget.value = false;
                    setColor(const Color.fromRGBO(177, 224, 255, 1));
                  })
              : Container()
        ],
      ),
    );
  }

  Future<List<Widget>> mapUserFolders(Function(Map) onFileSelected,
      Function(String) onDownload, String filter, bool order) async {
    List<Widget> listWidgets = [];
    if (folderName.value == 'Archivos') {
      List<Directories> folders = user.directories;
      folders.sort((a, b) => order
          ? a.nameDirectory
              .toLowerCase()
              .compareTo(b.nameDirectory.toLowerCase())
          : b.nameDirectory
              .toLowerCase()
              .compareTo(a.nameDirectory.toLowerCase()));
      for (var directory in user.directories) {
        if (directory.nameDirectory != 'Default${user.user}' &&
            (filter == "" || filter == "Folder")) {
          listWidgets.addAll(await displayFolder(directory.nameDirectory));
        }
      }

      listWidgets.addAll(await displayFolder('Default${user.user}',
          showFiles: true,
          onTap: onFileSelected,
          onDownload: onDownload,
          filter: filter,
          order: order));
    } else {
      var folder = user.directories
          .firstWhere((dir) => dir.nameDirectory == folderName.value,
              orElse: () => Directories({"nameDirectory": ""}))
          .nameDirectory;
      if (folder != "") {
        listWidgets.addAll(await displayFolder(folder,
            showFiles: true,
            onTap: onFileSelected,
            onDownload: onDownload,
            filter: filter,
            order: order));
      }
    }
    return listWidgets;
  }

  Future<List<Widget>> displayFolder(String directory,
      {bool showFiles = false,
      Function(String)? onDownload,
      Function(Map)? onTap,
      String filter = "",
      bool order = true}) async {
    String apiPath =
        'https://api-drivehub-production.up.railway.app/api/files/unidad';
    Directories folder =
        user.directories.firstWhere((dir) => dir.nameDirectory == directory);

    if (showFiles) {
      List<Widget> files = [];
      List<Files> folderFiles = folder.files;
      folderFiles.sort((a, b) => order
          ? a.nameFile.toLowerCase().compareTo(b.nameFile.toLowerCase())
          : b.nameFile.toLowerCase().compareTo(a.nameFile.toLowerCase()));

      for (var file in folderFiles) {
        if (filter != "" && (filter != typeKey(file.nameFile))) {
          continue;
        }
        final filePath =
            Uri.parse('$apiPath/${user.userName}/$directory/${file.nameFile}')
                .toString();

        final directoryLocal = await getApplicationDocumentsDirectory();
        final imagePreview =
            '${directoryLocal.path}/${file.nameFile.split('.').sublist(0, file.nameFile.split('.').length - 1).join('.')}.png';

        final isImage = isImageFile(file.nameFile);
        final isVideo = isVideoFile(file.nameFile);
        final iconCard =
            isImage ? iconImage : (isVideo ? iconVideo : iconDocument);

        files.add(GestureDetector(
          onTap: () => onTap!({
            'file': file,
            'filePath': filePath,
            "folder": directory,
            "icon": iconCard,
            "image": imagePreview,
            "isImage": isImage,
            "isVideo": isVideo
          }),
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
                          color: fileType[typeKey(file.nameFile)]['Color'],
                          borderRadius: BorderRadius.circular(5)),
                      child: fileType[typeKey(file.nameFile)]['Icon']),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(file.nameFile,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromRGBO(65, 86, 110, 1))),
                      const SizedBox(height: 4),
                      Text(
                        formatFileSize(file.size),
                        style: const TextStyle(
                            fontSize: 15,
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
                          showDialog(
                              context: Get.context!,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()));
                          String currentPath = await downloadFile(
                              filePath, file.nameFile, onDownload!);
                          Navigator.pop(Get.context!);
                          if (currentPath != "") {
                            openFile(currentPath);
                          }
                          break;
                        case 'Compartir link':
                          Map<String, dynamic> map =
                              await shareFile(file.nameFile, directory);
                          String? path = map["link"];
                          if (path != null) {
                            Share.share(
                                'SafeSync App\n\nTe comparto mi archivo: ${file.nameFile}\nlink: $path');
                          }
                          break;
                        case 'Mostrar QR':
                          Map<String, dynamic> map =
                              await shareFile(file.nameFile, directory);
                          String? path = map["link"];
                          if (path != null) {
                            showQRDialog(file.nameFile, path);
                          }
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
                          value: 'Compartir link',
                          child: Text('Compartir link')),
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
        GestureDetector(
          onTap: () => folderName.value = directory,
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
                Icon(Icons.folder_rounded,
                    color: Colors.red.shade500, size: 68),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(directory,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromRGBO(65, 86, 110, 1))),
                      const SizedBox(height: 4),
                      Text(
                        formatFileSize(totalSize),
                        style: const TextStyle(
                            fontSize: 15,
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
}

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

String formatFileSize(double sizeInBytes) {
  if (sizeInBytes < 1000) {
    return '${sizeInBytes.toStringAsFixed(1)} bytes';
  } else if (sizeInBytes < 1000 * 1000) {
    double sizeInKb = sizeInBytes / 1000;
    return '${sizeInKb.toStringAsFixed(1)} KB';
  } else if (sizeInBytes < 1000 * 1000 * 1000) {
    double sizeInMb = sizeInBytes / (1000 * 1000);
    return '${sizeInMb.toStringAsFixed(1)} MB';
  } else {
    double sizeInGb = sizeInBytes / (1000 * 1000 * 1000);
    return '${sizeInGb.toStringAsFixed(1)} GB';
  }
}

String typeKey(String fileName) => isImageFile(fileName)
    ? 'Imagen'
    : (isVideoFile(fileName) ? 'Video' : 'Documento');

bool isImageFile(String fileName) {
  final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp', 'svg'];
  final lowerCaseFileName = fileName.toLowerCase();
  return imageExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

bool isVideoFile(String fileName) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.flv', '.wmv', 'webm'];
  final lowerCaseFileName = fileName.toLowerCase();
  return videoExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

const iconImage = Icon(Icons.image_rounded,
    size: 89, color: Color.fromARGB(255, 228, 75, 255));
final iconVideo =
    Icon(Icons.play_arrow_rounded, size: 89, color: Colors.red.shade500);
const iconDocument = Icon(Icons.description, size: 89, color: Colors.blue);

void showQRDialog(String fileName, String qrCodeBase64) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(fileName,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            maxLines: 1),
        content: QrImageView(
          data: qrCodeBase64,
          errorStateBuilder: (cxt, err) {
            return const Center(
              child: Text(
                'Uh oh! ocurrio un error...',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
