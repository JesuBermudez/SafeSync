import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget startPageButton() {
  return ElevatedButton(
    onPressed: () {
      Get.offNamed("/login");
    },
    style: ButtonStyle(
        elevation: MaterialStateProperty.all(15),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor:
            MaterialStateProperty.all(const Color.fromARGB(123, 0, 110, 255)),
        fixedSize: MaterialStateProperty.all(const Size(190, 60)),
        padding: MaterialStateProperty.all(EdgeInsets.zero)),
    child: Ink(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              Color.fromRGBO(48, 79, 255, 1),
              Color.fromRGBO(0, 165, 255, 1)
            ],
          ),
          borderRadius: BorderRadius.circular(15.0)),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(width: 20),
            Text("Comenzar", style: TextStyle(fontSize: 22)),
            SizedBox(width: 15),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    ),
  );
}
