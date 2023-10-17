import 'package:flutter/material.dart';

Widget titleLabel(String textContent, {double? fontSize}) {
  return Text(
    textContent,
    style: TextStyle(
        color: const Color.fromRGBO(0, 81, 151, 1),
        fontSize: fontSize ?? 22,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            color: Color.fromARGB(70, 0, 110, 255),
            offset: Offset(1, 1),
            blurRadius: 6,
          )
        ]),
  );
}

Widget subtitleLabel(String textContent, {Color? color}) {
  return Text(textContent,
      style: TextStyle(
          color: color ?? Colors.blueGrey.shade800,
          fontSize: 18,
          fontWeight: FontWeight.w600));
}
