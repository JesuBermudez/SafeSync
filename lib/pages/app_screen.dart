import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/pages/home_page.dart';
import 'package:safesync/pages/launch_page.dart';
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
          if (user.email.value.isNotEmpty) {
            return const AppContent();
          } else {
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.data!.isEmpty || snapshot.hasError) {
                Future.delayed(const Duration(seconds: 1), () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offNamed("/login");
                  });
                });
              }
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return const AppContent();
            } else {
              return const Scaffold(body: LaunchPage());
            }
          }
        });
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.wb_cloudy_outlined),
                  activeIcon: Icon(Icons.wb_cloudy_outlined)),
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.folder_outlined),
                  activeIcon: Icon(Icons.folder_outlined))
            ]),
        body: HomePage());
  }
}
