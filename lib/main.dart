import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:safesync/models/support/support.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/app.dart';

void main() {
  runApp(const MyApp());
  Get.put(User());
  Get.put(Support());
}
