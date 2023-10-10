import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget recentFiles() {
  return Container(
    width: 150,
    height: 150,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(
          color: Color.fromARGB(125, 13, 72, 161),
          offset: Offset(2, 2),
          blurRadius: 7)
    ], borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.more_horiz,
              color: Color.fromRGBO(54, 93, 125, 1),
            ))
      ],
    ),
  );
}
