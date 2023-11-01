import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/services/file/file.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';
import 'package:safesync/ui/cards/card_recent_files.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class FileOpen extends StatelessWidget {
  final Map file;
  final VoidCallback onClose;
  final Function(String) onDownload;
  FileOpen(
      {super.key,
      required this.file,
      required this.onClose,
      required this.onDownload});

  ValueNotifier<double?> width = ValueNotifier<double?>(null);
  ValueNotifier<double?> height = ValueNotifier<double?>(null);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  var widthObs = 0.0.obs;
  var localPath = "".obs;
  var isExpanded = false.obs;
  var isDownloading = false.obs;

  @override
  Widget build(BuildContext context) {
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
                          (file["isVideo"] || file["isImage"])
                              ? fileThumbnailWidget()
                              : !isDownloading.value
                                  ? IconButton(
                                      onPressed: () async {
                                        isDownloading.value = true;
                                        String path = await downloadFile(
                                            file["filePath"],
                                            file["file"].namefile,
                                            (path) => localPath.value = path);
                                        isDownloading.value = false;
                                        if (path != "") {
                                          openFile(path);
                                        }
                                      },
                                      icon: file["icon"],
                                      iconSize: 180,
                                      padding: const EdgeInsets.all(40))
                                  : const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          100, 100, 100, 148),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  color: Colors.indigoAccent)),
                                          Icon(Icons.download,
                                              color: Colors.indigoAccent,
                                              size: 46)
                                        ],
                                      ),
                                    ),
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
    if (!isPlaying.value &&
        (widthObs.value != 0 || !(file["isImage"] || file["isVideo"]))) {
      return AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 150),
        width: widthObs.value != 0.0 ? getWidth(widthObs.value) : 260,
        height: isExpanded.value ? 200 : 54,
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
                InkWell(
                  onTap: () => openWith(
                      file["filePath"], file['file'].nameFile, onDownload),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      'Abrir con',
                      style: TextStyle(
                          fontSize: 18, color: Colors.blueGrey.shade900),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => shareLink(file['file'].nameFile, file['folder']),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      'Compartir link',
                      style: TextStyle(
                          fontSize: 18, color: Colors.blueGrey.shade900),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => shareQr(file['file'].nameFile, file['folder']),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      'Compartir Qr',
                      style: TextStyle(
                          fontSize: 18, color: Colors.blueGrey.shade900),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    deleteFile([file['file'].nameFile], file['folder']);
                    onClose();
                  },
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      'Eliminar',
                      style: TextStyle(
                          fontSize: 18, color: Colors.blueGrey.shade900),
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
          },
        ),
      );

      return ValueListenableBuilder(
          valueListenable: isPlaying,
          builder: (context, isPlayingValue, child) {
            if (isPlayingValue) {
              return FutureBuilder<Map<String, dynamic>>(
                future: shareFile(file["file"].nameFile, file["folder"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras se espera la respuesta.
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Maneja cualquier error que ocurra durante la solicitud.
                    return Text('Ocurrió un error: ${snapshot.error}');
                  } else {
                    String? path = snapshot.data?["link"];
                    if (path == null) {
                      // Si path es null, retorna un ícono o cualquier otro widget.
                      return const Padding(
                        padding: EdgeInsets.all(100),
                        child:
                            Icon(Icons.error, size: 180, color: Colors.amber),
                      );
                    } else {
                      final VideoPlayerController controller =
                          VideoPlayerController.networkUrl(Uri.parse(path));
                      final ChewieController chewieController =
                          ChewieController(
                        videoPlayerController: controller,
                        autoInitialize: true,
                        autoPlay: false,
                        looping: false,
                      );
                      return AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: Chewie(
                          controller: chewieController,
                        ),
                      );
                    }
                  }
                },
              );
            } else {
              return ValueListenableBuilder<double?>(
                valueListenable: width,
                builder:
                    (BuildContext context, double? widthValue, Widget? child) {
                  if (widthValue != null && height.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey.shade200,
                        width: widthValue,
                        height: getHeight(height.value, widthValue),
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
                                  isPlaying.value = true;
                                  widthObs.value = 1;
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
          });
    } else if (file["isImage"]) {
      final Image image = Image.network(file["filePath"]);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool syncCall) {
            width.value = getWidth(info.image.width.toDouble());
            widthObs.value = getWidth(info.image.width.toDouble());
            height.value = getHeight(
                info.image.height.toDouble(), info.image.width.toDouble());
          },
        ),
      );

      return ValueListenableBuilder<double?>(
        valueListenable: width,
        builder: (BuildContext context, double? widthValue, Widget? child) {
          if (widthValue != null && height.value != null) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Container(
                  color: Colors.grey.shade200,
                  width: widthValue,
                  height: height.value,
                  child: Center(
                      child: FittedBox(fit: BoxFit.contain, child: image))),
            );
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
