import 'package:get/get.dart';
import 'package:safesync/models/user/file.dart';

class Directories extends GetxController {
  var nameDirectory = "";
  List<Files> files = [];

  Directories(Map<String, dynamic> json) {
    nameDirectory = json["nameDirectory"];
    if (json["files"] != null) {
      files =
          (json["files"] as List).map((fileJson) => Files(fileJson)).toList();
    }
  }
}
