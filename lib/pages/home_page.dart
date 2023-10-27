import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/ui/containers/file_open_container.dart';

import 'package:safesync/icons/icons.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/cards/card_file_category.dart';
import 'package:safesync/ui/cards/card_recent_files.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final Function(Color) setColor;
  HomePage(this.setColor, {super.key});

  User user = Get.find();
  TextEditingController search = TextEditingController();
  var isShowingFileWidget = false.obs;
  var selectedFile = {}.obs;
  String localPath = "";

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
                SearchInput(controller: search),
                const SizedBox(height: 30),
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
                                  () {}),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.folder,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Carpetas",
                                  () {},
                                  Colors.red.shade500),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.image_rounded,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Fotos",
                                  () {},
                                  const Color.fromARGB(255, 228, 75, 255)),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Videos",
                                  () {},
                                  Colors.cyan.shade300),
                              const SizedBox(width: 12),
                              fileCategory(
                                  const Icon(Icons.description,
                                      color: Colors.white, size: 60),
                                  const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                  "Archivos",
                                  () {},
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
                        future: getRecentFilesWidgets(user, (path) async {
                          if (localPath != path) {
                            final File file = File(localPath);
                            if (await file.exists()) {
                              await file.delete();
                            }
                          }
                          localPath = path;
                        }, (file) {
                          selectedFile.value = file;
                          isShowingFileWidget.value = true;
                          setColor(const Color.fromARGB(255, 82, 114, 143));
                        }),
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
      );
    });
  }
}

const iconImage = Icon(Icons.image_rounded,
    size: 89, color: Color.fromARGB(255, 228, 75, 255));
final iconVideo =
    Icon(Icons.play_arrow_rounded, size: 89, color: Colors.red.shade500);
const iconDocument = Icon(Icons.description, size: 89, color: Colors.blue);

Future<String> downloadFile(String url, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$filename';
  final file = File(filePath);

  if (!file.existsSync()) {
    // Si el archivo no existe, descargarlo
    try {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      return "";
    }
  }

  return filePath;
}

Future<List<Widget>> getRecentFilesWidgets(User user,
    Function(String) onDownload, Function(Map) onFileSelected) async {
  final recentFilesList = <Widget>[];

  List<Map<String, dynamic>> allFiles = [];
  final previewImages = 'Default${user.userName}';

  // Recorrer todas las carpetas y recopilar todos los archivos
  for (final directory in user.directories) {
    for (final file in directory.files) {
      allFiles.add({
        'file': file,
        'directoryName': directory.nameDirectory.value,
      });
    }
  }

  allFiles.sort((a, b) => b['file'].date.compareTo(a['file'].date));

  for (final item in allFiles) {
    final file = item['file'];
    final directoryName = item['directoryName'];
    final fileNamePreview =
        "${file.nameFile.split('.').sublist(0, file.nameFile.split('.').length - 1).join('.')}.png";

    String apiPath =
        'https://api-drivehub-production.up.railway.app/api/files/unidad';

    final isImage = _isImageFile(file.nameFile);
    final isVideo = _isVideoFile(file.nameFile);
    final iconCard = isImage ? iconImage : (isVideo ? iconVideo : iconDocument);

    Image? imageCard;
    String imagePreview =
        Uri.parse("$apiPath/$previewImages/$fileNamePreview").toString();

    if (user.shouldShowImage.value && (isImage || isVideo)) {
      try {
        String localFilePath =
            await downloadFile(imagePreview, fileNamePreview);
        if (localFilePath == "") {
          imageCard = null;
        } else {
          File imageFile = File(localFilePath);
          imagePreview = localFilePath;
          imageCard = Image.file(imageFile,
              width: 130,
              height: 84,
              errorBuilder: (context, error, stackTrace) => iconCard);
        }
      } catch (e) {
        imageCard = null;
      }
    }

    final titleCard = file.nameFile;
    final dateFile = getDateFile(file.date);
    final weight = formatFileSize(file.size);
    final filePath =
        Uri.parse('$apiPath/${user.userName}/$directoryName/${file.nameFile}')
            .toString();

    recentFilesList.add(
      recentFiles(
          iconCard: iconCard,
          imageCard: imageCard,
          titleCard: titleCard,
          dateCard: dateFile,
          weightCard: weight,
          folderName: directoryName,
          filePath: filePath,
          onDownload: onDownload,
          onTap: () => onFileSelected({
                'file': file,
                'filePath': filePath,
                "icon": iconCard,
                "image": imagePreview,
                "isImage": isImage,
                "isVideo": isVideo
              })),
    );
  }

  return recentFilesList;
}

bool _isImageFile(String fileName) {
  final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp', 'svg'];
  final lowerCaseFileName = fileName.toLowerCase();
  return imageExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

bool _isVideoFile(String fileName) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.flv', '.wmv', 'webm'];
  final lowerCaseFileName = fileName.toLowerCase();
  return videoExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

String getDateFile(String date) {
  DateTime apiDate = DateTime.parse(date);
  DateTime now = DateTime.now();
  Duration difference = now.difference(apiDate);

  if (difference.inDays == 0) {
    return "Hoy";
  } else if (difference.inDays == 1) {
    return "Ayer";
  } else if (difference.inDays < 30) {
    return "Hace ${difference.inDays} días";
  } else if (difference.inDays < 365) {
    int months = difference.inDays ~/ 30;
    return "Hace $months meses";
  } else {
    int years = difference.inDays ~/ 365;
    return "Hace $years años";
  }
}

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
