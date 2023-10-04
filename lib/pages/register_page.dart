import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/containers/containers.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //Fondo azul con logo y nombre de la app
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: Get.height > 800 ? 215 : 150,
            child: const ContainerTitle(),
          ),

          //Contenedor de los imputs
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: Get.height > 800 ? 120 : 70,
            child: ContainerInputs(
              view: true,
              textContainer: 'Registrarse',
              labelUsername: 'Usuario',
            ),
          ),
        ],
      ),
    );
  }
}
