import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';

// ignore: must_be_immutable
class FileOpen extends StatelessWidget {
  final Map file;
  final VoidCallback onClose;
  FileOpen({super.key, required this.file, required this.onClose});

  ValueNotifier<double?> width = ValueNotifier<double?>(null);
  ValueNotifier<double?> height = ValueNotifier<double?>(null);

  var padd = 0.0.obs;
  var widthObs = 0.0.obs;
  var localPath = "".obs;
  var isExpanded = false.obs;
  var isDownloading = false.obs;

  @override
  Widget build(BuildContext context) {
    padd.value = !(file["isImage"] || file["isVideo"]) ? 48 : 0;
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final File file = File(localPath.value);
            if (await file.exists()) {
              await file.delete();
            }
            onClose();
          },
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // AppBar
        Positioned(
            top: 0,
            child: uploadAppBar("${file['file'].nameFile}", () async {
              final File file = File(localPath.value);
              if (await file.exists()) {
                await file.delete();
              }
              onClose();
            })),
        // File
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 57, bottom: 2),
            child: Container(
              width: Get.width,
              height: Get.height,
              alignment: Alignment.center,
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: padd.value),
                              child: (file["isVideo"] || file["isImage"])
                                  ? fileThumbnailWidget()
                                  : !isDownloading.value
                                      ? IconButton(
                                          onPressed: () async {
                                            isDownloading.value = true;
                                            String path = await downloadFile(
                                                file["filePath"],
                                                file["file"].namefile,
                                                (path) =>
                                                    localPath.value = path);
                                            isDownloading.value = false;
                                            if (path != "") {
                                              openFile(path);
                                            }
                                          },
                                          icon: file["icon"],
                                          iconSize: 180,
                                          padding: const EdgeInsets.all(40))
                                      : const Padding(
                                          padding: EdgeInsets.all(100),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          color: Colors
                                                              .indigoAccent)),
                                              Icon(Icons.download,
                                                  color: Colors.indigoAccent,
                                                  size: 46)
                                            ],
                                          ),
                                        )),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: animatedContainerWidget()),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        )
      ],
    );
  }

  Widget animatedContainerWidget() {
    if (widthObs.value != 0 || !(file["isImage"] || file["isVideo"])) {
      return AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 150),
        width: widthObs.value != 0.0 ? getWidth(widthObs.value) : 260,
        height: isExpanded.value ? 150 : 54,
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
                      isExpanded.value
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      color: const Color.fromRGBO(2, 103, 212, 1)),
                  iconSize: 34,
                  onPressed: () {
                    isExpanded.value = !isExpanded.value;
                  },
                ),
              ),
              if (isExpanded.value) ...[
                const Text('Abrir con'),
                const Text('Compartir'),
                const Text('Eliminar'),
              ]
            ],
          ),
        ),
      );
    } else {
      return SizedBox(width: widthObs.value == 0 ? 0 : 1);
    }
  }

  Widget fileThumbnailWidget() {
    if (file["isVideo"]) {
      final Image image = Image.file(File(file["image"]));
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            width.value = getWidth(info.image.width.toDouble());
            widthObs.value = getWidth(info.image.width.toDouble());
            height.value = getHeight(
                info.image.height.toDouble(), info.image.width.toDouble());
            if (widthObs.value != 0) {
              padd.value = 48;
            }
          },
        ),
      );

      return ValueListenableBuilder<double?>(
        valueListenable: width,
        builder: (BuildContext context, double? widthValue, Widget? child) {
          if (widthValue != null && height.value != null) {
            return Container(
              alignment: Alignment.center,
              color: Colors.grey.shade200,
              width: widthValue,
              height: getHeight(height.value, widthObs.value),
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
                        onPressed: () => {} //openFile(localPath.value),
                        ),
                  )
                ],
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
    } else if (file["isImage"]) {
      final Image image = Image.network(file["filePath"]);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool syncCall) {
            width.value = getWidth(info.image.width.toDouble());
            widthObs.value = getWidth(info.image.width.toDouble());
            height.value = getHeight(
                info.image.height.toDouble(), info.image.width.toDouble());
            if (widthObs.value != 0) {
              padd.value = 48;
            }
          },
        ),
      );

      return ValueListenableBuilder<double?>(
        valueListenable: width,
        builder: (BuildContext context, double? widthValue, Widget? child) {
          if (widthValue != null && height.value != null) {
            return Container(
                color: Colors.grey.shade200,
                width: widthValue,
                height: height.value,
                child: Center(
                    child: FittedBox(fit: BoxFit.contain, child: image)));
          } else {
            return const Padding(
              padding: EdgeInsets.all(15.0),
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return const SizedBox();
    }
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
