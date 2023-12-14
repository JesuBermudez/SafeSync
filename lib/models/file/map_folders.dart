import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file/display_folders.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/user/directory.dart';
import 'package:safesync/models/user/user.dart';

Future<List<Widget>> mapFolders() async {
  User user = Get.find();
  FilePageController filePageController = Get.find();
  List<Widget> listWidgets = [];

  if (filePageController.folderName.value == 'Archivos   ') {
    // ignore: invalid_use_of_protected_member
    List<Directories> folders = user.directories.value;

    folders.sort((a, b) => filePageController.descOrder.value
        ? a.nameDirectory.toLowerCase().compareTo(b.nameDirectory.toLowerCase())
        : b.nameDirectory
            .toLowerCase()
            .compareTo(a.nameDirectory.toLowerCase()));

    for (var directory in user.directories) {
      if (directory.nameDirectory != 'Default${user.user}' &&
          (filePageController.filterOption.value == "" ||
              filePageController.filterOption.value == "Folder") &&
          directory.nameDirectory.toLowerCase().contains(
              filePageController.searchValue.value.toLowerCase().trim())) {

        listWidgets.addAll(await displayFolder(directory.nameDirectory));
      }
    }

    listWidgets
        .addAll(await displayFolder('Default${user.user}', showFiles: true));
  } else {
    var folder = user.directories
        .firstWhere(
            (dir) => dir.nameDirectory == filePageController.folderName.value,
            orElse: () => Directories({"nameDirectory": ""}))
        .nameDirectory;

    if (folder != "") {
      listWidgets.addAll(await displayFolder(folder, showFiles: true));
    }
  }
  
  return listWidgets;
}
