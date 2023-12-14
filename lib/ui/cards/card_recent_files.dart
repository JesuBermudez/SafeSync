import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/services/file/file.dart';

Widget recentFiles(
    {Icon? iconCard,
    Image? imageCard,
    required String titleCard,
    String? dateCard,
    String? weightCard,
    required String folderName,
    required String filePath,
    required Function() onTap}) {
  FileController fileController = Get.find();

  return InkWell(
    onTap: onTap,
    child: Container(
      width: 150,
      height: 170,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(90, 13, 72, 161),
            offset: Offset(2, 2),
            blurRadius: 7)
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // se muestra la imagen spoiler, sino, el icono de documento, y sino, un icono por defecto
                imageCard != null
                    ? Container(
                        width: 130.0,
                        height: 84,
                        margin: const EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: imageCard,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: (iconCard ??
                            const Icon(Icons.question_mark_rounded, size: 84)),
                      ),
                Container(
                  alignment: Alignment.center,
                  width: 130,
                  child: Column(
                    children: [
                      Text(
                        titleCard,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Color.fromRGBO(55, 81, 115, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      fileController.buildVariableText('$dateCard', '$weightCard'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -2,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz,
                  color: Color.fromRGBO(54, 93, 125, 1),
                ),
                onSelected: (String result) async {
                  switch (result) {
                    case 'Abrir con':
                      fileController.openWith(filePath, titleCard);
                      break;
                    case 'Compartir link':
                      fileController.shareLink(titleCard, folderName);
                      break;
                    case 'Mostrar QR':
                      fileController.showQR(titleCard, folderName);
                      break;
                    case 'Borrar':
                      deleteFile([titleCard], folderName);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'Abrir con', child: Text('Abrir con')),
                  const PopupMenuItem<String>(
                      value: 'Compartir link', child: Text('Compartir link')),
                  const PopupMenuItem(
                      value: 'Mostrar QR', child: Text('Mostrar QR')),
                  const PopupMenuItem<String>(
                      value: 'Borrar', child: Text('Borrar')),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}