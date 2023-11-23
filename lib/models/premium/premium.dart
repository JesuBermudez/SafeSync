import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/services/user/user.dart';

class PremiumController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idController = TextEditingController();
  final cardNumberController = TextEditingController();

  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Compra de cuenta premium'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese sus apellidos';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Cédula'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su cédula';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Por favor ingrese solo números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cardNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Número de tarjeta'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el número de tarjeta';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Por favor ingrese solo números';
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                updateMembership();
                Get.back();
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    lastNameController.dispose();
    idController.dispose();
    cardNumberController.dispose();
    super.onClose();
  }
}
