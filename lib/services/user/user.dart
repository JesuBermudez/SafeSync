import 'dart:async';

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
    print(sucess);

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
