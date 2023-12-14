import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:safesync/services/file/file.dart';

Widget videoPlayback() {
  FilePageController filePageController = Get.find();

  return FutureBuilder<Map<String, dynamic>>(
    future: shareFile(filePageController.selectedFile!.file!.nameFile, filePageController.selectedFile!.folderName),
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
            child: Icon(Icons.error, size: 180, color: Colors.amber),
          );
        } else {
          final VideoPlayerController controller =
              VideoPlayerController.networkUrl(Uri.parse(path));
          final ChewieController chewieController = ChewieController(
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
}
