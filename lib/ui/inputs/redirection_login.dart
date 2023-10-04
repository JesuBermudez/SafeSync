import 'package:flutter/material.dart';
import 'package:get/get.dart';

createRedirection({required String text, required String textLink}) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Text(
      '$text ',
      style: const TextStyle(
        fontSize: 16.0,
      ),
    ),
    InkWell(
        onTap: () {
          // pantalla para iniciar sesión
          textLink == "Inicia sesión aquí"
              ? Get.offNamed("/login")
              : Get.offNamed("/register");
        },
        child: Text(
          textLink,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ))
  ]);
}
