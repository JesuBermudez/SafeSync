import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  var currentIndex = 2.obs;
  var filterOption = "".obs;
  var scaffoldBackground = Rx<Color>(const Color.fromRGBO(177, 224, 255, 1));
  final inactiveColor = const Color.fromRGBO(148, 167, 190, 1);
  final activeColor = const Color.fromRGBO(2, 103, 212, 1);

  setScaffoldBackground(Color color) {
    scaffoldBackground.value = color;
  }

  setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  setFilterOption(String option) {
    filterOption.value = option;
  }
}