import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user/user.dart';
import 'api_login.dart';

void login() async {
  User user = Get.find();
  // ignore: unrelated_type_equality_checks
  if (user.mail == '' || user.pass == '') {
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('¡ATENCIÓN!'),
        content: Text('Por favor, no deje campos vacios.'),
      ),
    );
    return;
  }

  // Show loading indicator
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
        content: SizedBox(
      width: 10,
      height: 120,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
      ),
    )),
  );

  ApiService apiService = ApiService();

  try {
    String sucess = await apiService.login();

    // Hide loading indicator
    Navigator.pop(Get.context!);

    if (sucess == 'OK') {
      // ignore: use_build_context_synchronously
      Get.offNamed("/");
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: const Text('Error al iniciar sesión'),
          content: Text(sucess),
        ),
      );
    }
  } catch (e) {
    // Hide loading indicator
    Navigator.pop(Get.context!);

    // ignore: use_build_context_synchronously
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error al iniciar sesión'),
        content: Text('Error desconocido'),
      ),
    );
  }
}
