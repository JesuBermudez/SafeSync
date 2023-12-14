import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/services/file/file.dart';

Widget animatedContainerWidget() {
  FilePageController filePageController = Get.find();
  FileController fileController = Get.find();

  if (filePageController.selectedFile!.isPlaying.value &&
      (filePageController.selectedFile!.width.value != 0 ||
          !(filePageController.selectedFile!.isImage ||
              filePageController.selectedFile!.isVideo))) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 150),
      width: filePageController.selectedFile!.width.value != 0.0
          ? filePageController.selectedFile!.getWidth(filePageController.selectedFile!.width.value)
          : 260,
      height: filePageController.selectedFile!.isExpanded.value ? 200 : 54,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(90, 96, 125, 139),
                blurRadius: 4,
                spreadRadius: 4)
          ]),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: IconButton(
                icon: Icon(
                    filePageController.selectedFile!.isExpanded.value
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: const Color.fromRGBO(2, 103, 212, 1)),
                iconSize: 34,
                onPressed: () {
                  filePageController.selectedFile!.isExpanded.value =
                      !filePageController.selectedFile!.isExpanded.value;
                },
              ),
            ),
            if (filePageController.selectedFile!.isExpanded.value) ...[
              InkWell(
                onTap: () => fileController.openWith(filePageController.selectedFile!.filePath, filePageController.selectedFile!.file!.nameFile),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    'Abrir con',
                    style: TextStyle(
                        fontSize: 16, color: Colors.blueGrey.shade900),
                  ),
                ),
              ),
              InkWell(
                onTap: () => fileController.shareLink(filePageController.selectedFile!.file!.nameFile, filePageController.selectedFile!.folderName),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    'Compartir link',
                    style: TextStyle(
                        fontSize: 16, color: Colors.blueGrey.shade900),
                  ),
                ),
              ),
              InkWell(
                onTap: () => fileController.showQR(filePageController.selectedFile!.file!.nameFile, filePageController.selectedFile!.folderName),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    'Compartir Qr',
                    style: TextStyle(
                        fontSize: 16, color: Colors.blueGrey.shade900),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  deleteFile([filePageController.selectedFile!.file!.nameFile], filePageController.selectedFile!.folderName);
                  fileController.onClose();
                },
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                        fontSize: 16, color: Colors.blueGrey.shade900),
                  ),
                ),
              ),
              const SizedBox(height: 2)
            ]
          ],
        ),
      ),
    );
  } else {
    return SizedBox(width: filePageController.selectedFile!.width.value == 0 ? 0 : 1);
  }
}
