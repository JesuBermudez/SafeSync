import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final double content = Get.height - Get.width > 300
      ? (Get.height * 0.15) + (Get.width * 0.8) + 140
      : (Get.height * 0.15) + 540;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // Color de fondo
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, 0.0),
          end: Alignment(1, 0.70),
          colors: <Color>[
            Color.fromRGBO(244, 250, 255, 1),
            Color.fromRGBO(176, 210, 255, 1),
          ],
        ),
      ),
      //
      child: Column(
        children: [
          SizedBox(height: (Get.height - content) * 0.35),
          // Imagen
          Image.asset(
            "assets/Digital personal files-amico.png",
            width: (Get.height - Get.width > 300) ? Get.width * 0.8 : 400,
          ),
          SizedBox(height: (Get.height - content) * 0.25),
          // Titulo
          const Text("Almacenamiento en la nube",
              style: TextStyle(
                  color: Color.fromRGBO(29, 50, 85, 1),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(73, 0, 0, 0),
                    ),
                  ])),
          // Texto
          Padding(
              padding: EdgeInsets.fromLTRB(
                  (Get.width * 0.15) - 15, 20, (Get.width * 0.15) - 15, 0),
              child: const Text(
                "Todos tus archivos disponibles en todo momento en un solo lugar",
                style: TextStyle(
                    color: Color.fromRGBO(45, 45, 45, 1), fontSize: 24),
                textAlign: TextAlign.center,
              )),
          SizedBox(height: (Get.height - content) * 0.5),
          // Boton
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(20),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  shadowColor: MaterialStateProperty.all(
                    const Color.fromARGB(80, 41, 109, 255),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  fixedSize: MaterialStateProperty.all(
                    const Size(220, 60),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(11, 97, 236, 1),
                        Color.fromRGBO(90, 180, 251, 1)
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
