import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/file/file_with_directory.dart';
import 'package:safesync/models/file_queue/file_queue_controller.dart';
import 'package:safesync/models/file_queue/queued_file.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/cards/card_recent_files.dart';
import 'package:safesync/ui/containers/file_open_container.dart';
import 'package:share_plus/share_plus.dart';

class FileController extends GetxController {
  final iconImage = const Icon(Icons.image_rounded,
      size: 89, color: Color.fromARGB(255, 228, 75, 255));
  final iconVideo =
      Icon(Icons.play_arrow_rounded, size: 89, color: Colors.red.shade500);
  final iconDocument =
      const Icon(Icons.description, size: 89, color: Colors.blue);

  Widget buildVariableText(String text1, String text2) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const style = TextStyle(
            color: Color.fromRGBO(88, 115, 150, 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600);
        final span1 = TextSpan(text: text1, style: style);
        final span2 = TextSpan(text: text2, style: style);
        const dash = TextSpan(text: ' - ', style: style);

        final tp1 = TextPainter(text: span1, textDirection: TextDirection.ltr);
        tp1.layout();
        final tp2 = TextPainter(text: span2, textDirection: TextDirection.ltr);
        tp2.layout();
        final tpDash =
            TextPainter(text: dash, textDirection: TextDirection.ltr);
        tpDash.layout();

        if (tp1.width + tpDash.width + tp2.width <= constraints.maxWidth) {
          // Si las dos variables y el guión caben en una línea
          return Text.rich(
            TextSpan(
              children: [span1, dash, span2],
              style: style,
            ),
          );
        } else {
          // Si no caben en una línea
          return Column(
            children: [
              Text(text1, style: style),
              Text(text2, style: style),
            ],
          );
        }
      },
    );
  }

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

  void openWith(String filePath, String fileName) async {
    FileQueueController fileQueueController = Get.find();
    QueuedFile file = QueuedFile(
        const Icon(Icons.download_rounded, color: Colors.blue, size: 20),
        fileName);
    fileQueueController.addToQueue(file);

    String currentPath = await downloadFile(filePath, fileName);
    if (currentPath != "") {
      openFile(currentPath);
      fileQueueController.removeFromQueue(file);
    }
  }

  void shareLink(String fileName, String folderName) async {
    Map<String, dynamic> map = await shareFile(fileName, folderName);
    String? path = map["link"];
    if (path != null) {
      Share.share(
          'SafeSync App\n\nTe comparto mi archivo: $fileName\nlink: $path');
    }
  }

  void showQR(String fileName, String folderName) async {
    // calculating the size
    final size =
        Get.width * 0.5 < Get.height * 0.8 ? Get.width * 0.5 : Get.height * 0.7;
    // get link
    Map<String, dynamic> map = await shareFile(fileName, folderName);
    String? fileUrl = map["link"];

    if (fileUrl != null) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          // show alertDialog
          return AlertDialog(
            title: Text(fileName,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 1),
            content: Container(
              alignment: Alignment.center,
              height: size,
              width: size,
              child: QrImageView(size: size, data: fileUrl),
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
  }

  Widget getFileOpen() {
    FilePageController filePageController = Get.find();
    return filePageController.isShowingFileWidget.value
        ? FileOpen()
        : Container();
  }

  Future<List<Widget>> getRecentFilesWidgets() async {
    User user = Get.find();
    FilePageController filePageController = Get.find();
    List<Widget> recentFilesList = [];
    List<FileWithDirectory> filesWithDirectories = [];
    final previewImages = 'Default${user.userName}';

    // Recorrer todas las carpetas y recopilar todos los archivos
    for (final directory in user.directories) {
      for (final file in directory.files) {
        filesWithDirectories
            .add(FileWithDirectory(file, directory.nameDirectory));
      }
    }

    filesWithDirectories.sort((a, b) => b.file.date.compareTo(a.file.date));

    for (final file in filesWithDirectories) {
      final fileNamePreview =
          "${file.file.nameFile.split('.').sublist(0, file.file.nameFile.split('.').length - 1).join('.')}.png";

      String apiPath =
          'https://api-drivehub-production.up.railway.app/api/files/unidad';

      final isImage = filePageController.isImageFile(file.file.nameFile);
      final isVideo = filePageController.isVideoFile(file.file.nameFile);
      final iconCard =
          isImage ? iconImage : (isVideo ? iconVideo : iconDocument);

      Image? imageCard;
      String imagePreview =
          Uri.parse("$apiPath/$previewImages/$fileNamePreview")
              .toString(); // from api server

      // gets imagen preview if it's not a document
      if (isImage || isVideo) {
        String localFilePath = await downloadFile(
            imagePreview, fileNamePreview); // get local preview imagen
        if (localFilePath == "") {
          // error downloading preview
          imageCard = null;
        } else {
          File imageFile = File(localFilePath);
          imagePreview = localFilePath;

          imageCard = Image.file(imageFile,
              width: 130,
              height: 84,
              errorBuilder: (context, error, stackTrace) => iconCard);
        }
      }

      final titleCard = file.file.nameFile;
      final dateFile = filePageController.getDateFile(file.file.date);
      final weight = filePageController.formatFileSize(file.file.size);
      // url to file from api server
      final filePath = Uri.parse(
              '$apiPath/${user.userName}/$file.directoryName/${file.file.nameFile}')
          .toString();

      recentFilesList.add(recentFiles(
          iconCard: iconCard,
          imageCard: user.shouldShowImage.value ? imageCard : null,
          titleCard: titleCard,
          dateCard: dateFile,
          weightCard: weight,
          folderName: file.directoryName,
          filePath: filePath,
          onTap: () {
            filePageController.setFileSelected(file.file, filePath,
                file.directoryName, iconCard, imagePreview, isImage, isVideo);
          }));
    }

    return recentFilesList;
  }
}
