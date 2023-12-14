import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/app/app_controller.dart';
import 'package:safesync/models/file/file_selected.dart';
import 'package:safesync/models/user/file.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/containers/file_open_container.dart';
import 'package:safesync/ui/containers/upload_container.dart';

class FilePageController extends GetxController {
  TextEditingController searchController = TextEditingController();
  Widget uploadForm = const SizedBox();
  var seeOptions = false.obs;
  var upload = false.obs;
  var folderName = Rx<String>("Archivos   ");
  var isShowingFileWidget = false.obs;
  FileSelected? selectedFile;
  var filterOption = "".obs;
  var descOrder = true.obs;
  var searchValue = "".obs;
  String localPath = "";

  setFilterOption(String option) => filterOption.value = option;

  setSearch(String value) => searchValue.value = value;

  setOrder() => descOrder.toggle();

  setUpload(bool value) => upload.value = value;

  setSeeOptions(bool value) => seeOptions.value = value;

  setUploadForm(Widget widget) => uploadForm = widget;

  setFileSelected(Files file, String filePath, String folderName, Icon icon,
      String imagePreview, bool isImage, bool isVideo) {
    AppController appController = Get.find();
    selectedFile = FileSelected(
        file, filePath, folderName, icon, imagePreview, isImage, isVideo);
    appController
        .setScaffoldBackground(const Color.fromARGB(255, 82, 114, 143));
    isShowingFileWidget.value = true;
  }

  setFolderName(String value) => folderName.value = value;

  getFolderName() => folderName.value == 'Archivos   ' ? '' : folderName.value;

  getUploadForm() {
    if (!upload.value) {
      return const SizedBox();
    }

    return uploadForm;
  }

  getFileOpen() {
    if (!isShowingFileWidget.value) {
      return const SizedBox();
    }

    return FileOpen();
    /* onClose: () {
                    isShowingFileWidget.value = false;
                    setColor(const Color.fromRGBO(177, 224, 255, 1));
                  } */
  }

  onCloseFile() {
    AppController appController = Get.find();
    appController.setScaffoldBackground(const Color.fromRGBO(177, 224, 255, 1));
    isShowingFileWidget.value = false;
    selectedFile = null;
  }

  deleteLocalFile() async {
    final File file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  onDownload(String path) async {
    if (localPath != path) {
      deleteLocalFile();
    }
    localPath = path;
  }

  onUploadFolder() {
    AppController appController = Get.find();

    appController
        .setScaffoldBackground(const Color.fromARGB(255, 82, 114, 143));

    setUploadForm(uploadContainer(
        title: "Crear carpeta",
        onClose: () {
          appController
              .setScaffoldBackground(const Color.fromRGBO(177, 224, 255, 1));
          setUploadForm(const SizedBox());
          setUpload(false);
        }));

    setSeeOptions(false);
    setUpload(true);
  }

  onUploadFile() async {
    AppController appController = Get.find();

    Map<String, String> fileData = await obtenerArchivo();

    if (!fileData.containsKey("canceled")) {
      appController
          .setScaffoldBackground(const Color.fromARGB(255, 82, 114, 143));
      setUploadForm(uploadContainer(
          title: "Subir archivo",
          folderName: getFolderName(),
          fileData: fileData,
          onClose: () {
            appController
                .setScaffoldBackground(const Color.fromRGBO(177, 224, 255, 1));
            setUploadForm(const SizedBox());
            setUpload(false);
          }));

      setUpload(true);
    }
    setSeeOptions(false);
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
}
