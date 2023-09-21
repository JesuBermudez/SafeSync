import 'package:flutter/material.dart';

createButton(String text) {
  return ElevatedButton(
    onPressed: () {},
    style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(20),
        fixedSize: const MaterialStatePropertyAll(Size(200, 45)),
        shadowColor: const MaterialStatePropertyAll(Colors.blue),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
    child: Text(
      text,
      style: const TextStyle(fontSize: 20),
    ),
  );
}
