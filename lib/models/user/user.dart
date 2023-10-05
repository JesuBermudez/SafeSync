import 'package:get/get.dart';

class User extends GetxController {
  var userName = "".obs;
  var password = "".obs;
  var email = "".obs;
  var token = "".obs;

  dataUser(var userEmail, var userPassword, [var username = ""]) {
    userName.value = username;
    email.value = userEmail;
    password.value = userPassword;
    print("dataUser ${toJson()}");
  }

  void clear() {
    userName.value = '';
    password.value = '';
    email.value = '';
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
