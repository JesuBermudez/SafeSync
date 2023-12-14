import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_page_controller.dart';

Widget imageFile() {
  FilePageController filePageController = Get.find();

  final Image image = Image.network(filePageController.selectedFile!.filePath);
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo info, bool syncCall) {
        filePageController.selectedFile!.width.value = filePageController
            .selectedFile!
            .getWidth(info.image.width.toDouble());
        filePageController.selectedFile!.widthN.value = filePageController
            .selectedFile!
            .getWidth(info.image.width.toDouble());
        filePageController.selectedFile!.height =
            filePageController.selectedFile!.getHeight(
                info.image.height.toDouble(), info.image.width.toDouble());
      },
    ),
  );

  return ValueListenableBuilder<double?>(
    valueListenable: filePageController.selectedFile!.widthN,
    builder: (BuildContext context, double? widthValue, Widget? child) {
      if (widthValue != null && filePageController.selectedFile!.height != 0) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Container(
              color: Colors.grey.shade200,
              width: widthValue,
              height: filePageController.selectedFile!.height,
              child:
                  Center(child: FittedBox(fit: BoxFit.contain, child: image))),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
