import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/ui/appBars/upload_appbar.dart';
import 'package:safesync/ui/containers/expanded_container.dart';


// ignore: must_be_immutable
class FileOpen extends StatelessWidget {
  FileOpen({super.key});

  FilePageController filePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark background 
        InkWell(
          onTap: () {
            filePageController.deleteLocalFile();
            filePageController.onCloseFile();
          },
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // AppBar
        Positioned(
            top: 0,
            child: uploadAppBar(filePageController.selectedFile!.file!.nameFile,
                () {
              filePageController.deleteLocalFile();
              filePageController.onCloseFile();
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
                          filePageController.selectedFile!.getFileView(),
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
}