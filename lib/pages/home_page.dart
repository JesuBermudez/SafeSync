import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/inputs/search_input.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PagesContainer(
        content: Column(
      children: [SearchInput(controller: search)],
    ));
  }
}
