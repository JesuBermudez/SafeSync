import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/icons/icons.dart';
import 'package:safesync/ui/cards/card_file_category.dart';
import 'package:safesync/ui/cards/card_recent_files.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cardSpace = (Get.width - (Get.width * 0.08)) - 10;
    return PagesContainer(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchInput(controller: search),
          const SizedBox(height: 30),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleLabel("Almacenamiento"),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fileCategory(
                                const Icon(
                                  SafeSyncIcons.foursquares,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                "Todo",
                                () {}),
                            const SizedBox(width: 12),
                            fileCategory(
                                const Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                "Carpetas",
                                () {},
                                Colors.red[500]),
                            const SizedBox(width: 12),
                            fileCategory(
                                const Icon(
                                  Icons.image_rounded,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                "Fotos",
                                () {},
                                const Color.fromARGB(255, 228, 75, 255)),
                            const SizedBox(width: 12),
                            fileCategory(
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                const EdgeInsets.fromLTRB(15, 13, 15, 12),
                                "Videos",
                                () {},
                                Colors.cyan[200])
                          ],
                        )),
                    const SizedBox(height: 30),
                    Row(children: [
                      titleLabel("Reciente"),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_downward_rounded,
                          color: Color.fromRGBO(0, 81, 151, 1))
                    ]),
                    SizedBox(height: 15),
                    Wrap(
                        runSpacing: 20,
                        spacing: (cardSpace - (150 * (cardSpace ~/ 150))) /
                            ((cardSpace ~/ 150) - 1),
                        children: [recentFiles(), recentFiles(), recentFiles()])
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
