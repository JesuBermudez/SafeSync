import 'package:flutter/material.dart';

createButton(
    {required String text, VoidCallback? registerd, VoidCallback? login}) {
  return ElevatedButton(
    onPressed: text == 'Registrarse' ? registerd : () {},
    style: ButtonStyle(
      elevation: const MaterialStatePropertyAll(20),
      fixedSize: const MaterialStatePropertyAll(Size(300, 55)),
      shadowColor:
          const MaterialStatePropertyAll(Color.fromARGB(150, 33, 37, 243)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
    ),
    child: Ink(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                Color.fromRGBO(90, 180, 251, 1),
                Color.fromRGBO(11, 97, 236, 1),
              ],
            ),
            borderRadius: BorderRadius.circular(50.0)),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        )),
  );
}
