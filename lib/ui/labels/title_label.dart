import 'package:flutter/material.dart';

Widget titleLabel(String textContent) {
  return Text(
    textContent,
    style: const TextStyle(
        color: Color.fromRGBO(0, 81, 151, 1),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Color.fromARGB(90, 0, 0, 0),
            offset: Offset(1, 1),
            blurRadius: 6,
          )
        ]),
  );
}
