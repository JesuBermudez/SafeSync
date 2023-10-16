import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Color.fromRGBO(244, 250, 255, 1),
            Color.fromRGBO(154, 209, 255, 1),
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
                textAlign: TextAlign.center,
              )),
          SizedBox(height: (Get.height - content) * 0.5),
          // Boton
          Align(
              alignment: const Alignment(0.8, 1),
              child: ElevatedButton(
                onPressed: () {
                  Get.offNamed("/login");
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(15),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    shadowColor: MaterialStateProperty.all(
                      const Color.fromARGB(123, 0, 110, 255),
                    ),
                    fixedSize: MaterialStateProperty.all(
                      const Size(190, 60),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(48, 79, 255, 1),
                        Color.fromRGBO(0, 165, 255, 1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Comenzar",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}
