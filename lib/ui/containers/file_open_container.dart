import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:open_file/open_file.dart';

// ignore: must_be_immutable
class FileOpen extends StatelessWidget {
  final Map file;
  final VoidCallback onClose;
  FileOpen({super.key, required this.file, required this.onClose});

  ValueNotifier<double?> width = ValueNotifier<double?>(null);
  ValueNotifier<double?> height = ValueNotifier<double?>(null);
  var localPath = "".obs;
  var isExpanded = false.obs;

  Future<String> downloadFile(String url, String filename) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      return "";
    }
    var filePath = '${directory.path}/$filename';
    var file = File(filePath);

    if (!file.existsSync()) {
      // Descargar el archivo
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
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
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 3.5),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 1),
                  blurRadius: 10,
                  spreadRadius: 5),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                    onPressed: () async {
                      final File file = File(localPath.value);
                      if (await file.exists()) {
                        await file.delete();
                      }
                      onClose();
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 24,
                      color: Colors.blueGrey.shade900,
                    )),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    "${file['file'].namefile}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ),
        ),
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
                              padding:
                                  (localPath.value != "" || width.value != null)
                                      ? const EdgeInsets.only(bottom: 50)
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
                                              iconSize: 170,
                                              padding: const EdgeInsets.all(35),
                                            );
                                          }
                                        } else {
                                          return const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child:
                                                  CircularProgressIndicator());
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

  Widget animatedContainerWidget() {
    Timer(const Duration(milliseconds: 100), () {});
    if (localPath.value != "" && width.value != null) {
      return AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 150),
        width: getWidth(width.value),
        height: isExpanded.value ? 150 : 50,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
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
              IconButton(
                icon: Icon(
                  isExpanded.value ? Icons.arrow_downward : Icons.arrow_upward,
                  color: const Color.fromRGBO(2, 103, 212, 1),
                ),
                iconSize: 34,
                onPressed: () {
                  isExpanded.value = !isExpanded.value;
                },
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
    } else if (localPath.value != "") {
      return AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 150),
        width: 240,
        height: isExpanded.value ? 150 : 50,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
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
              IconButton(
                icon: Icon(
                    isExpanded.value
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: const Color.fromRGBO(2, 103, 212, 1)),
                iconSize: 34,
                onPressed: () {
                  isExpanded.value = !isExpanded.value;
                },
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
                            width.value = info.image.width.toDouble();
                            height.value = info.image.height.toDouble();
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
                              width: getWidth(widthValue),
                              height: getHeight(height.value),
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
                child: CircularProgressIndicator());
          }
        },
      );
    } else if (file["isImage"]) {
      final Image image = Image.network(file["filePath"]);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            width.value = info.image.width.toDouble();
            height.value = info.image.height.toDouble();
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
                          width: getWidth(widthValue),
                          height: getHeight(height.value),
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
                child: CircularProgressIndicator(),
              );
            }
          });
    } else {
      return const SizedBox();
    }
  }
}

double getWidth(double? width) =>
    width! > Get.width ? (Get.width > 500 ? 500 : Get.width) : width;

double getHeight(double? height) =>
    height! > Get.height - 200 ? height / 3 : height;

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
