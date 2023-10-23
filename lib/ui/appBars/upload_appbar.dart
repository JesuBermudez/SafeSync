import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget uploadAppBar(String title, VoidCallback onClose) {
  return Container(
    width: Get.width,
    padding: const EdgeInsets.symmetric(vertical: 3.5),
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
          color: Colors.black38,
          offset: Offset(0, 1),
          blurRadius: 10,
          spreadRadius: 5),
    ]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
            onPressed: () => onClose(),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: Colors.blueGrey.shade900,
            )),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            style: TextStyle(
                fontSize: 21,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        const SizedBox(width: 5)
      ],
    ),
  );
}
