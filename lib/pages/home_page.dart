import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/ui/containers/file_open_container.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:safesync/icons/icons.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/cards/card_file_category.dart';
import 'package:safesync/ui/cards/card_recent_files.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  User user = Get.find();
  TextEditingController search = TextEditingController();
  var isShowingFileWidget = false.obs;
  var selectedFile = {}.obs;

  @override
  Widget build(BuildContext context) {
    final cardSpace = (Get.width - (Get.width * 0.08)) - 10;
    final spacing =
        (cardSpace - (150 * (cardSpace ~/ 150))) / ((cardSpace ~/ 150) - 1);
    return Stack(
      children: [
        PagesContainer(
          content: Stack(
            children: [
              Column(
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
                                    const Icon(
                                      SafeSyncIcons.foursquares,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                    const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    "Todo",
                                    () {}),
                                const SizedBox(width: 12),
                                fileCategory(
                                    const Icon(
                                      Icons.folder,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                    "Carpetas",
                                    () {},
                                    Colors.red[500]),
                                const SizedBox(width: 12),
                                fileCategory(
                                    const Icon(
                                      Icons.image_rounded,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                    "Fotos",
                                    () {},
                                    const Color.fromARGB(255, 228, 75, 255)),
                                const SizedBox(width: 12),
                                fileCategory(
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                    "Videos",
                                    () {},
                                    Colors.cyan[300]),
                                const SizedBox(width: 12),
                                fileCategory(
                                    const Icon(
                                      Icons.description,
                                      color: Colors.white,
                                      size: 60,
                                    ),
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
                          future: getRecentFilesWidgets(user, (file) {
                            selectedFile.value = file;
                            isShowingFileWidget.value = true;
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
              )
            ],
          ),
        ),
        isShowingFileWidget.value
            ? Positioned(
                top: 0,
                left: 0,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isShowingFileWidget.value = false;
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: fileOpen(
                        file: selectedFile.value,
                        onClose: () {
                          isShowingFileWidget.value = false;
                        },
                      ),
                    )
                  ],
                ))
            : Container()
      ],
    );
  }
}

const iconImage = Icon(Icons.image_rounded, size: 89, color: Colors.green);
const iconVideo = Icon(Icons.play_arrow, size: 89, color: Colors.red);
const iconDocument = Icon(Icons.description, size: 89, color: Colors.blue);

Future<String> downloadFile(String url, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$filename';
  final file = File(filePath);

  if (!file.existsSync()) {
    // Si el archivo no existe, descargarlo
    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
  }

  return filePath;
}

Future<List<Widget>> getRecentFilesWidgets(
    User user, Function(Map) onFileSelected) async {
  final recentFilesList = <Widget>[];

  List<Map<String, dynamic>> allFiles = [];

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

    String filePath = Uri.parse(
            'https://safesync.fly.dev/api/files/unidad/${user.userName}/$directoryName/${file.nameFile}')
        .toString();

    final isImage = _isImageFile(file.nameFile);
    final isVideo = _isVideoFile(file.nameFile);
    final iconCard = user.shouldShowImage.value
        ? (!isImage && !isVideo ? iconDocument : null)
        : (isImage ? iconImage : (isVideo ? iconVideo : iconDocument));

    Image? imageCard;

    if (user.shouldShowImage.value && (isImage || isVideo)) {
      String localFilePath = await downloadFile(filePath, file.nameFile);

      if (isVideo) {
        final thumbnailData = await _generateVideoThumbnail(localFilePath);
        if (thumbnailData != null) {
          imageCard = Image.memory(thumbnailData, width: 130, height: 84);
        }
      } else if (isImage) {
        final compressedImageData = await _compressImage(localFilePath);
        if (compressedImageData != null) {
          imageCard = Image.memory(compressedImageData, width: 130, height: 84);
        }
      }
    }

    final titleCard = file.nameFile;
    final dateFile = getDateFile(file.date);
    final weight = "4 MB";

    recentFilesList.add(
      recentFiles(
          iconCard: iconCard,
          imageCard: imageCard,
          titleCard: titleCard,
          dateCard: dateFile,
          weightCard: weight,
          onTap: () => onFileSelected({'file': file, 'filePath': filePath})),
    );
  }

  return recentFilesList;
}

bool _isImageFile(String fileName) {
  final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp'];
  final lowerCaseFileName = fileName.toLowerCase();
  return imageExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

bool _isVideoFile(String fileName) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.flv', '.wmv'];
  final lowerCaseFileName = fileName.toLowerCase();
  return videoExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

Future<Uint8List?> _generateVideoThumbnail(String videoPath) async {
  final result = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 130,
    quality: 25,
  );
  return result;
}

Future<Uint8List?> _compressImage(String imagePath) async {
  final result = await FlutterImageCompress.compressWithFile(
    imagePath,
    minHeight: 84,
    minWidth: 130,
    quality: 65,
  );
  return result;
}

String getDateFile(String date) {
  String apiDateString = date
      .replaceRange(4, 5, "-")
      .replaceRange(7, 8, "-")
      .replaceRange(10, 11, "T")
      .replaceRange(13, 14, ":")
      .replaceRange(16, 17, ":");
  DateTime apiDate = DateTime.parse(apiDateString);
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
