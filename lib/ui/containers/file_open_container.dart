import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:open_file/open_file.dart';

// ignore: must_be_immutable
class FileOpen extends StatelessWidget {
  final Map file;
  final VoidCallback onClose;
  FileOpen({super.key, required this.file, required this.onClose});

  ValueNotifier<double?> width = ValueNotifier<double?>(null);
  ValueNotifier<double?> height = ValueNotifier<double?>(null);
  var widthObs = 0.0.obs;
  var localPath = "".obs;
  var isExpanded = false.obs;

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
            child: uploadAppBar("${file['file'].namefile}", () async {
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
                              padding: (localPath.value != "" ||
                                      widthObs.value != 0.0)
                                  ? const EdgeInsets.only(bottom: 48)
                                  : EdgeInsets.zero,
                              child: (file["isVideo"] || file["isImage"])
                                  ? fileThumbnailWidget()
                                  : FutureBuilder<String?>(
                                      future: downloadFile(file["filePath"],
                                          file["file"].namefile),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String?> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError ||
                                              snapshot.data == null) {
                                            return const Column(
                                              children: [
                                                Icon(Icons.error_outline,
                                                    color: Colors.orange,
                                                    size: 55),
                                                Text(
                                                    "Error al descargar el archivo.")
                                              ],
                                            );
                                          } else {
                                            return IconButton(
                                              onPressed: () =>
                                                  openFile(localPath.value),
                                              icon: file["icon"],
                                              iconSize: 180,
                                              padding: const EdgeInsets.all(40),
                                            );
                                          }
                                        } else {
                                          return const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Icon(
                                                    Icons.download,
                                                    color: Colors.blue,
                                                    size: 28,
                                                  )
                                                ],
                                              ));
                                        }
                                      },
                                    )),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: animatedContainerWidget())
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

  Future<String> downloadFile(String url, String filename) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      return "";
    }
    var filePath = '${directory.path}/$filename';
    var file = File(filePath);

    if (!file.existsSync()) {
      // Descargar el archivo
      try {
        final response = await http.get(Uri.parse(url));
        await file.writeAsBytes(response.bodyBytes);
      } catch (e) {
        showDialog(
            context: Get.context!,
            builder: (_) => AlertDialog(
                  title: const Text("Error"),
                  content: Text('Error al abrir el archivo: $filename'),
                ));
        Get.offNamed("/login");
      }
    }
    localPath.value = filePath;

    return filePath;
  }

  Future<Uint8List?> fetchThumbnail(String videoPath) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );

      return uint8list;
    } catch (e) {
      return null;
    }
  }

  Widget animatedContainerWidget() {
    Timer(const Duration(milliseconds: 100), () {});
    if (localPath.value != "") {
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
      return SizedBox(width: isExpanded.value ? 0 : 1);
    }
  }

  Widget fileThumbnailWidget() {
    if (file["isVideo"]) {
      return FutureBuilder<String?>(
        future: downloadFile(file["filePath"], file["file"].namefile),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return Icon(
                Icons.video_file_rounded,
                color: Colors.cyan.shade300,
                size: 120,
              );
            } else {
              return FutureBuilder<Uint8List?>(
                future: fetchThumbnail(snapshot.data!),
                builder: (BuildContext context,
                    AsyncSnapshot<Uint8List?> thumbnailSnapshot) {
                  if (thumbnailSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (thumbnailSnapshot.hasError ||
                        thumbnailSnapshot.data == null) {
                      return IconButton(
                        onPressed: () => openFile(localPath.value),
                        icon: Icon(
                          Icons.video_file_rounded,
                          color: Colors.cyan.shade300,
                          size: 170,
                        ),
                        padding: const EdgeInsets.all(35),
                      );
                    } else {
                      final Image image = Image.memory(thumbnailSnapshot.data!);
                      image.image
                          .resolve(const ImageConfiguration())
                          .addListener(
                        ImageStreamListener(
                          (ImageInfo info, bool _) {
                            width.value = getWidth(info.image.width.toDouble());
                            widthObs.value =
                                getWidth(info.image.width.toDouble());
                            height.value = getHeight(
                                info.image.height.toDouble(),
                                info.image.width.toDouble());
                          },
                        ),
                      );

                      return ValueListenableBuilder<double?>(
                        valueListenable: width,
                        builder: (BuildContext context, double? widthValue,
                            Widget? child) {
                          if (widthValue != null && height.value != null) {
                            return Container(
                              color: Colors.grey.shade200,
                              width: widthValue,
                              height: getHeight(height.value, widthObs.value),
                              child: Stack(
                                children: [
                                  Center(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child:
                                          Image.memory(thumbnailSnapshot.data!),
                                    ),
                                  ),
                                  Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.play_circle),
                                      color: Colors.blue,
                                      iconSize: 55,
                                      onPressed: () =>
                                          openFile(localPath.value),
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
                    }
                  } else {
                    // indicador de progreso mientras se carga el thumbnail.
                    return const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CircularProgressIndicator());
                  }
                },
              );
            }
          } else {
            return const Padding(
                padding: EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Icon(
                      Icons.download,
                      color: Colors.blue,
                      size: 28,
                    )
                  ],
                ));
          }
        },
      );
    } else if (file["isImage"]) {
      final Image image = Image.network(file["filePath"]);
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
      return FutureBuilder<String?>(
          future: downloadFile(file["filePath"], file["file"].namefile),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || snapshot.data == null) {
                return const Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.orange, size: 55),
                    Text("Error al descargar el archivo.")
                  ],
                );
              } else {
                return ValueListenableBuilder<double?>(
                  valueListenable: width,
                  builder: (BuildContext context, double? widthValue,
                      Widget? child) {
                    if (widthValue != null && height.value != null) {
                      return Container(
                          color: Colors.grey.shade200,
                          width: widthValue,
                          height: height.value,
                          child: Center(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: GestureDetector(
                                      onTap: () async {
                                        await downloadFile(file["filePath"],
                                            file["file"].namefile);
                                        if (localPath.value != "") {
                                          openFile(localPath.value);
                                        }
                                      },
                                      child: image))));
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
            } else {
              return const Padding(
                padding: EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Icon(
                      Icons.download,
                      color: Colors.blue,
                      size: 28,
                    )
                  ],
                ),
              );
            }
          });
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

void openFile(String pathToFile) async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    final result = await OpenFile.open(pathToFile);

    if (result.type != ResultType.done) {
      showDialog(
          context: Get.context!,
          builder: (_) => AlertDialog(
                title: Text(pathToFile.split("/")[-1]),
                content: Text('Error al abrir el archivo: ${result.message}'),
              ));
    }
  }
}
