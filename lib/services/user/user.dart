import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user/user.dart';
import 'api_user.dart';

Future<String> getUser() async {
  User user = Get.find();
  final prefs = await SharedPreferences.getInstance();

  final userId = prefs.getString('userId');
  final userToken = prefs.getString('userToken');
  final userApp = prefs.getBool('firstTime');

  if (userApp == null) {
    return "firstTime";
  }

  ApiService apiService = ApiService();

  try {
    Map<String, dynamic> sucess = await apiService.getUser(userId!, userToken!);

    if (!sucess.containsKey("Error")) {
      user.jsonFromUser(sucess);

      return "Session";
    } else {
      return "";
    }
  } catch (e) {
    return "";
  }
}

void updateMembership() async {
  User user = Get.find();

  final prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('userToken');

  ApiService apiService = ApiService();

  showDialog(
      context: Get.context!,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  try {
    String sucess = await apiService.updateMembership(user.user, userToken!);

    Navigator.pop(Get.context!);

    if (sucess == 'Ok') {
      user.premium.toggle();
      showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          title: Container(
              padding: const EdgeInsets.all(4),
              width: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.amber])),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium_rounded,
                      color: Colors.white, size: 20),
                  Text(
                    'Premium',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              )),
          content: const Text('Tu cuenta ahora es premium'),
        ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('Ocurrio un error, intente mas tarde.'),
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: Get.context!,
      builder: (_) => const AlertDialog(
        title: Text('Error'),
        content: Text('Ocurrio un error, intente mas tarde.'),
      ),
    );
  }
}
