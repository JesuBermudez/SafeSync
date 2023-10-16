import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/support/support.dart';
import 'package:safesync/services/support/api_support.dart';

void support() async {
  Support support = Get.find<Support>();
  if (!support.getSend) {
    if (support.getEmail == '' ||
        support.getSubject == '' ||
        support.getMessage == '') {
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
    ApiSupport apiService = ApiSupport();

    try {
      String sucess = await apiService.supportEmail();
      Navigator.pop(Get.context!);
      if (sucess == 'Email sent successfully') {
        showDialog(
          context: Get.context!,
          builder: (_) => const AlertDialog(
            title: Text('Enviado'),
            content: Text('Su mensaje fue enviado con exito'),
          ),
        );
        support.clear();
      } else {
        showDialog(
          context: Get.context!,
          builder: (_) => const AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo enviar el mensaje'),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo enviar el mensaje'),
        ),
      );
    }
  } else {
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Tomate un respiro'),
        content: Text('Ya enviaste tu mensaje'),
      ),
    );
    support.clear();
  }
}
