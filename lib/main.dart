import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:safesync/models/app/app_controller.dart';
import 'package:safesync/models/file/file_functions_controller.dart';
import 'package:safesync/models/file/file_page_controller.dart';
import 'package:safesync/models/file_queue/file_queue_controller.dart';
import 'package:safesync/models/support/support.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/app.dart';

void main() {
  runApp(const MyApp());
  Get.put(User());
  Get.put(Support());
  Get.put(AppController());
  Get.put(FileController());
  Get.put(FilePageController());
  Get.put(FileQueueController());
}
