import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1, 0.75),
        colors: <Color>[
          Color.fromRGBO(244, 250, 255, 1),
          Color.fromRGBO(155, 198, 255, 1),
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1500),
            child: Image.asset(
              'assets/logo-200.png',
              width: Get.height * 0.25,
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1500),
            child: Text('SafeSync',
                style: TextStyle(
                    fontSize: Get.height * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                          offset: Offset(1, 2),
                          color: Color.fromRGBO(114, 114, 114, 0.498),
                          blurRadius: 5.5)
                    ])),
          )
        ],
      ),
    );
  }
}
