import 'package:flutter/material.dart';

import '../ui/containers/containers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // final screenWidth = MediaQuery.of(context).size.width;
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
            top: 140,
            child: ContainerInputs(
              view: true,
              screenHeight: screenHeight,
              textContainer: 'Registrarse',
              labelUsername: 'Usuario',
            ),
          ),
        ],
      ),
    );
  }
}
