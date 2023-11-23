import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var password = "".obs;
  var avatar = "".obs;
  var premium = false.obs;
  var space = 0.0.obs;
  var directories = <Directories>[].obs;
  var shouldShowImage = true.obs;

  dataUser({String? userEmail, String? userPassword, String? username}) {
    userName.value = username ?? userName.value;
    email.value = userEmail ?? email.value;
    password.value = userPassword ?? password.value;
  }

  jsonFromUser(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();

    userName.value = json["userName"];
    email.value = json["email"];
    password.value = json["password"];
    avatar.value = json["avatar"];
    premium.value = json["premium"] ?? false;
    space.value = json["space"] > 0 ? json["space"].toDouble() : 1.0;
    shouldShowImage.value = prefs.getBool('shouldShowImage') ?? true;

    directories.value = json["directories"]
        .map<Directories>((dirJson) => Directories(dirJson))
        .toList();
  }

  void clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
    email.value = '';
    password.value = '';
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  String get user => userName.value;
  String get pass => password.value;
  String get mail => email.value;

  Map<String, dynamic> toJson() {
    return {
      'userName': user.split(' ').join(''),
      'email': mail,
      'password': pass
    };
  }

  Map<String, dynamic> toJsonForLogin() {
    return {'email': mail, 'password': pass};
  }
}

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

class Files {
  String nameFile = "";
  String date = "";
  double size = 0;

  Files(Map<String, dynamic> json) {
    nameFile = json["nameFile"];
    date = json["Date"];
    size = json["size"].toDouble();
  }
}
