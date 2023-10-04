import 'package:flutter/material.dart';
import '../ui/containers/containers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            top: 120,
            child:
                ContainerInputs(view: false, textContainer: 'Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
