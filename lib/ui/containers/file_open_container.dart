import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget fileOpen({required Map file, required VoidCallback onClose}) {
  return Stack(
    children: [
      GestureDetector(
        onTap: () => onClose(),
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      // AppBar
      Positioned(
        top: 0,
        child: Container(
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
                  "${file['file'].namefile}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 5)
            ],
          ),
        ),
      ),
      // File
      Center(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            width: Get.height * 0.39,
            height: 500),
      )
    ],
  );
}
