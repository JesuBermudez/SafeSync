import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user/user.dart';
import 'api_register.dart';

void register() async {
  User user = Get.find();
  // ignore: unrelated_type_equality_checks
  if (user.user == '' || user.mail == '' || user.pass == '') {
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
