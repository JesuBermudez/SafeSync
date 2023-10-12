import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PagesContainer extends StatelessWidget {
  PagesContainer({super.key, required this.content});

  Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment(0.0, 0.0),
        end: Alignment(1, 0.70),
        colors: <Color>[
          Color.fromRGBO(234, 245, 255, 1),
          Color.fromRGBO(167, 220, 255, 1),
        ],
      )),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Get.width * 0.04, Get.height * 0.01, Get.width * 0.04, 0),
          child: content,
        ),
      ),
    );
  }
}
