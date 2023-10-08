import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user/user.dart';
import '../ui/containers/containers.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final User user = Get.find();

  @override
  Widget build(BuildContext context) {
    user.clear();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //Fondo azul con logo y nombre de la app
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 215,
            child: ContainerTitle(),
          ),

          //Contenedor de los imputs
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 120,
            child: ContainerInputs(
              view: false,
              textContainer: 'Iniciar sesión',
              labelUsername: "",
            ),
          ),
        ],
      ),
    );
  }
}
