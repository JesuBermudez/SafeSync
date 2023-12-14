import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/app/app_controller.dart';
import 'package:safesync/models/file_queue/file_queue_controller.dart';
import 'package:safesync/pages/cloud_page.dart';
import 'package:safesync/pages/files_page.dart';
import 'package:safesync/pages/home_page.dart';
import 'package:safesync/pages/launch_page.dart';
import 'package:safesync/pages/settings_page.dart';
import 'package:safesync/pages/support_page.dart';
import 'package:safesync/services/user/user.dart';
import '../models/user/user.dart';

// ignore: must_be_immutable
class AppScreen extends StatelessWidget {
  AppScreen({super.key});

  User user = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.data!.isEmpty || snapshot.hasError) {
              Future.delayed(const Duration(seconds: 1), () {
                Get.offNamed("/login");
              });
            }
          }
          // if it is your first time
          if (snapshot.data == "firstTime") {
            Future.delayed(const Duration(seconds: 1), () {
              Get.offNamed("/startpage");
            });
          }
          // app content
          if (user.email.value.isNotEmpty ||
              snapshot.hasData &&
                  snapshot.data!.isNotEmpty &&
                  snapshot.data != "firstTime") {
            return AppContent();
          } else {
            // loading view
            return const Scaffold(body: LaunchPage());
          }
        });
  }
}

// ignore: must_be_immutable
class AppContent extends StatelessWidget {
  AppContent({super.key});

  AppController appController = Get.find();
  FileQueueController fileQueueController = Get.find();

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      CloudPage(),
      FilesPage(),
      HomePage(),
      const SupportPage(),
      SettingsPage()
    ];

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: appController.scaffoldBackground.value,
        // navigation bar
        bottomNavigationBar: Container(
            height: 60,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(23, 66, 126, 0.3),
                  spreadRadius: 15,
                  blurRadius: 14,
                  offset: Offset(8, 8),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),

            // childs navigation bar
            child: BottomNavigationBar(
                onTap: (value) => appController.setCurrentIndex(value),
                currentIndex: appController.currentIndex.value,
                selectedItemColor: appController.activeColor,
                selectedFontSize: 15,
                unselectedFontSize: 0,
                showUnselectedLabels: false,
                elevation: 0,
                selectedLabelStyle: const TextStyle(height: 0.8),
                // sections
                items: [
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.wb_cloudy_outlined,
                          color: appController.inactiveColor),
                      activeIcon: Icon(Icons.wb_cloudy,
                          color: appController.activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.folder_outlined,
                          color: appController.inactiveColor),
                      activeIcon:
                          Icon(Icons.folder, color: appController.activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.home_outlined,
                          size: 28, color: appController.inactiveColor),
                      activeIcon: Icon(Icons.home_rounded,
                          size: 28, color: appController.activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.insert_comment_outlined,
                          color: appController.inactiveColor),
                      activeIcon: Icon(Icons.comment,
                          color: appController.activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.settings_outlined,
                          color: appController.inactiveColor),
                      activeIcon: Icon(Icons.settings,
                          color: appController.activeColor))
                ])),
        // content
        body: SafeArea(
          child: Stack(
            children: [
              // current section
              IndexedStack(
                index: appController.currentIndex.value,
                children: pages,
              ),
              // queue files
              fileQueueController.queueCard(),
            ],
          ),
        ),
      );
    });
  }
}
