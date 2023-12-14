import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/models/user/file.dart';
import 'package:safesync/ui/file_content/image_file.dart';
import 'package:safesync/ui/file_content/static_video.dart';
import 'package:safesync/ui/file_content/video_playback.dart';

class FileSelected {
  Files? file;
  String filePath = "";
  String folderName = "";
  Icon? icon;
  String imagePreview = "";
  bool isImage = false;
  bool isVideo = false;
  double height = 0;
  var width = 0.0.obs;
  var isExpanded = false.obs;
  var isDownloading = false.obs;
  ValueNotifier<double?> widthN = ValueNotifier<double?>(null);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  FileSelected(this.file, this.filePath, this.folderName, this.icon,
      this.imagePreview, this.isImage, this.isVideo);

  onClose() {
    width.value = 0;
    height = 0;
    isPlaying.value = false;
  }

  setWidth(double value) => width.value = value;

  setHeight(double value) => height = value;

  onDownload() async {
    FileController fileController = Get.find();
    isDownloading.value = true;
    fileController.openWith(filePath, file!.nameFile);
    isDownloading.value = false;
  }

  Widget getFileView() {
    if (isVideo || isImage) {
      return fileThumbnailWidget();
    } else {
      if (!isDownloading.value) {
        return IconButton(
            onPressed: () => onDownload(),
            icon: icon!,
            iconSize: 180,
            padding: const EdgeInsets.all(40));
      } else {
        return const Padding(
          padding: EdgeInsets.fromLTRB(100, 100, 100, 148),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                      strokeWidth: 5, color: Colors.indigoAccent)),
              Icon(Icons.download, color: Colors.indigoAccent, size: 46)
            ],
          ),
        );
      }
    }
  }

  Widget fileThumbnailWidget() {
    if (isVideo) {
      final Image image = Image.file(File(imagePreview));
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            width.value = getWidth(info.image.width.toDouble());
            widthN.value = getWidth(info.image.width.toDouble());
            height = getHeight(
                info.image.height.toDouble(), info.image.width.toDouble());
          },
        ),
      );

      return ValueListenableBuilder(
          valueListenable: isPlaying,
          builder: (context, isPlayingValue, child) {
            if (isPlayingValue) {
              return videoPlayback();
            } else {
              return staticVideo(image);
            }
          });
    } else if (isImage) {
      return imageFile();
    } else {
      return const SizedBox();
    }
  }

  double getWidth(double? width) => width! > Get.width
      ? (Get.width > 500 ? 500 : Get.width)
      : (width < 200 ? width + (200 - width) : width);

  double getHeight(double? height, double? width) {
    double newWidth = getWidth(width);
    if (newWidth != width) {
      // Si el ancho fue ajustado, ajustar la altura proporcionalmente
      double aspectRatio = height! / width!;
      return (newWidth * aspectRatio > 100 ? newWidth * aspectRatio : 100);
    } else {
      // Si el ancho no fue ajustado
      return height! > Get.height - 200
          ? height / 3
          : (height < 200 ? height + (200 - height) : height);
    }
  }
}
