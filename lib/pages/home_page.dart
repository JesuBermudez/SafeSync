import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment(0.0, 0.0),
        end: Alignment(1, 0.70),
        colors: <Color>[
          Color.fromRGBO(244, 250, 255, 1),
          Color.fromRGBO(176, 210, 255, 1),
        ],
      )),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            Get.width * 0.02, Get.height * 0.01, Get.width * 0.02, 20),
      ),
    );
  }
}
