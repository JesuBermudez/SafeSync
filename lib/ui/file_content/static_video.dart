import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_page_controller.dart';

Widget staticVideo(Image image) {
  FilePageController filePageController = Get.find();

  return ValueListenableBuilder<double?>(
    valueListenable: filePageController.selectedFile!.widthN,
    builder: (BuildContext context, double? widthValue, Widget? child) {
      if (widthValue != null && filePageController.selectedFile!.height != 0) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.shade200,
            width: widthValue,
            height: filePageController.selectedFile!
                .getHeight(filePageController.selectedFile!.height, widthValue),
            child: Stack(
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: image,
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.play_circle),
                    color: Colors.blue,
                    iconSize: 55,
                    onPressed: () {
                      filePageController.selectedFile!.isPlaying.value = true;
                      filePageController.selectedFile!.width.value = 1;
                    },
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        // indicador de progreso mientras se carga el thumbnail.
        return const Padding(
          padding: EdgeInsets.all(15.0),
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
