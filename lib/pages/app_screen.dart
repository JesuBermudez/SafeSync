import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          if (snapshot.data == "firstTime") {
            Future.delayed(const Duration(seconds: 1), () {
              Get.offNamed("/startpage");
            });
          }
          if (user.email.value.isNotEmpty ||
              snapshot.hasData &&
                  snapshot.data!.isNotEmpty &&
                  snapshot.data != "firstTime") {
            return AppContent();
          } else {
            return const Scaffold(body: LaunchPage());
          }
        });
  }
}

// ignore: must_be_immutable
class AppContent extends StatelessWidget {
  AppContent({super.key});

  var scaffoldBackground = Rx<Color>(const Color.fromRGBO(177, 224, 255, 1));
  var currentIndex = 2.obs;
  var filterOption = RxString('');
  var uploadingFilesIcon =
      const Icon(Icons.cloud_upload_rounded, color: Colors.blue, size: 20);
  var uploadingFilesText = 'Subiendo';
  var uploadingFilesCount = 0.obs;

  @override
  Widget build(BuildContext context) {
    const inactiveColor = Color.fromRGBO(148, 167, 190, 1);
    const activeColor = Color.fromRGBO(2, 103, 212, 1);

    List<Widget> pages = [
      CloudPage(),
      FilesPage((Color color) {
        scaffoldBackground.value = color;
      }, (int count, {String? text, Icon? icon}) {
        if (icon != null) {
          uploadingFilesIcon = icon;
        }
        if (text != null) {
          uploadingFilesText = text;
        }
        uploadingFilesCount.value = uploadingFilesCount.value + count;
      }, filterOption),
      HomePage((Color color) {
        scaffoldBackground.value = color;
      }, (int count, {String? text, Icon? icon}) {
        if (icon != null) {
          uploadingFilesIcon = icon;
        }
        if (text != null) {
          uploadingFilesText = text;
        }
        uploadingFilesCount.value = uploadingFilesCount.value + count;
      }, (String filter) {
        filterOption.value = filter;
        currentIndex.value = 1;
      }),
      const SupportPage(),
      SettingsPage()
    ];

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: scaffoldBackground.value,
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
            child: BottomNavigationBar(
                onTap: (value) => currentIndex.value = value,
                currentIndex: currentIndex.value,
                selectedItemColor: activeColor,
                selectedFontSize: 15,
                unselectedFontSize: 0,
                showUnselectedLabels: false,
                elevation: 0,
                selectedLabelStyle: const TextStyle(height: 0.8),
                items: const [
                  BottomNavigationBarItem(
                      label: '•',
                      icon:
                          Icon(Icons.wb_cloudy_outlined, color: inactiveColor),
                      activeIcon: Icon(Icons.wb_cloudy, color: activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.folder_outlined, color: inactiveColor),
                      activeIcon: Icon(Icons.folder, color: activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.home_outlined,
                          size: 28, color: inactiveColor),
                      activeIcon: Icon(Icons.home_rounded,
                          size: 28, color: activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.insert_comment_outlined,
                          color: inactiveColor),
                      activeIcon: Icon(Icons.comment, color: activeColor)),
                  BottomNavigationBarItem(
                      label: '•',
                      icon: Icon(Icons.settings_outlined, color: inactiveColor),
                      activeIcon: Icon(Icons.settings, color: activeColor))
                ])),
        body: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: currentIndex.value,
                children: pages,
              ),
              uploadingFilesCount.value > 0
                  ? Positioned(
                      top: 5,
                      right: 5,
                      child: IntrinsicWidth(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(1, 1),
                                      blurRadius: 3)
                                ]),
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                uploadingFilesIcon,
                                const SizedBox(width: 5),
                                Text('$uploadingFilesText $uploadingFilesCount',
                                    style: const TextStyle(fontSize: 14))
                              ],
                            )),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      );
    });
  }
}
