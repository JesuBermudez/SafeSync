import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/containers/page_container.dart';
import 'package:safesync/ui/labels/title_label.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  User user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PagesContainer(
          content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          titleLabel('Configuración'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      offset: Offset(3, 3))
                ]),
            child: Row(
              children: [
                const Text(
                  'Miniatura de archivos',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(221, 1, 10, 49),
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Switch(
                    value: user.shouldShowImage.value,
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('shouldShowImage', value);
                      user.shouldShowImage.value = !user.shouldShowImage.value;
                    })
              ],
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => Get.offNamed('/login'),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7,
                          offset: Offset(3, 3))
                    ]),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.logout_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text('Cerrar sesión',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 10)
                ])),
          )
        ],
      )),
    );
  }
}
