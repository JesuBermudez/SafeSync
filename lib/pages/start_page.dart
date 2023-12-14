import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/ui/buttons/start_page_button.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final double content = (Get.height * 0.45) + 140;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // Color de fondo
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, -0.3),
          end: Alignment(1.5, 0.30),
          colors: <Color>[
            Color.fromRGBO(235, 245, 255, 1),
            Color.fromRGBO(165, 220, 255, 1),
          ],
        ),
      ),

      child: Column(
        children: [
          SizedBox(height: (Get.height - content) * 0.35),

          // Imagen
          Image.asset(
            "assets/Digital personal files-amico.png",
            height: Get.height * 0.3,
          ),
          SizedBox(height: (Get.height - content) * 0.25),

          // Titulo
          const Text("Almacenamiento en la nube",
              style: TextStyle(
                  color: Color.fromRGBO(29, 50, 85, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.5,
                      color: Color.fromARGB(73, 0, 0, 0),
                    ),
                  ])),

          // Texto
          Padding(
              padding: EdgeInsets.fromLTRB(
                  (Get.width - 300) / 2, 20, (Get.width - 300) / 2, 0),
              child: const Text(
                "Todos tus archivos disponibles en todo momento en un solo lugar",
                style: TextStyle(
                    color: Color.fromRGBO(45, 45, 45, 1), fontSize: 20),
                textAlign: TextAlign.center
              )),
              
          SizedBox(height: (Get.height - content) * 0.5),

          // Boton
          Align(
              alignment: const Alignment(0.8, 1),
              child: startPageButton())
        ],
      ),
    ));
  }
}
