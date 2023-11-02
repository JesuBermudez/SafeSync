import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user/user.dart';
import 'api_register.dart';

void register() async {
  User user = Get.find();
  final prefs = await SharedPreferences.getInstance();

  // ignore: unrelated_type_equality_checks
  if (user.user == '' || user.mail == '' || user.pass == '') {
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
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  ApiService apiService = ApiService();

  try {
    String sucess = await apiService.registerUser();

    // Hide loading indicator
    Navigator.pop(Get.context!);

    if (sucess == 'OK') {
      // ignore: use_build_context_synchronously
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Registrado'),
          content: Text('Fuiste registrado con exito'),
        ),
      );
      user.clear();
      prefs.setBool('firstTime', false);
      Get.offNamed("/login");
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: const Text('Error al ser registrado'),
          content: Text(sucess),
        ),
      );
    }
  } catch (e) {
    // Hide loading indicator
    Navigator.pop(Get.context!);

    print(e);

    // ignore: use_build_context_synchronously
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error al ser registrado'),
        content: Text('Error desconocido'),
      ),
    );
  }
}
