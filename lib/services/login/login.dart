import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user/user.dart';
import 'api_login.dart';

void login() async {
  User user = Get.find();
  final prefs = await SharedPreferences.getInstance();

  // ignore: unrelated_type_equality_checks
  if (user.mail == '' || user.pass == '') {
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Atención'),
        content: Text('Por favor, no deje campos vacíos.'),
      ),
    );
    return;
  }

  // Show loading indicator
  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  ApiService apiService = ApiService();

  try {
    Map<String, dynamic> sucess = await apiService.login();

    // Hide loading indicator
    Navigator.pop(Get.context!);

    if (sucess.containsKey('userEmailCorrect')) {
      user.jsonFromUser(sucess["userEmailCorrect"]);

      prefs.setString('userId', sucess["userEmailCorrect"]["_id"]);
      prefs.setString('userToken', sucess["token"]);
      prefs.setBool('firstTime', false);

      Get.offNamed("/app");
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(sucess['Error']),
        ),
      );
      print(sucess['Error']);
    }
  } catch (e) {
    // Hide loading indicator
    Navigator.pop(Get.context!);

    // ignore: use_build_context_synchronously
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('Error al iniciar sesión'),
      ),
    );
  }
}
