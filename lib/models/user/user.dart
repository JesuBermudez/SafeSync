import 'package:get/get.dart';

class User extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var password = "".obs;
  var avatar = "".obs;
  var premium = false.obs;
  var space = 0.obs;
  var directories = [].obs;

  dataUser(
      {String? userEmail,
      String? userPassword,
      String? username,
      String? userAvatar,
      bool? userPremium,
      int? userSpace,
      List? userDirectories}) {
    userName.value = username ?? userName.value;
    email.value = userEmail ?? email.value;
    password.value = userPassword ?? password.value;
    avatar.value = userAvatar ?? avatar.value;
    premium.value = userPremium ?? premium.value;
    space.value = userSpace ?? space.value;
    // ignore: invalid_use_of_protected_member
    directories.value = userDirectories ?? directories.value;
  }

  void clear() {
    email.value = '';
    password.value = '';
  }

  String get user => userName.value;
  String get pass => password.value;
  String get mail => email.value;

  Map<String, dynamic> toJson() {
    return {'userName': user, 'email': mail, 'password': pass};
  }

  Map<String, dynamic> toJsonForLogin() {
    return {'email': mail, 'password': pass};
  }
}
