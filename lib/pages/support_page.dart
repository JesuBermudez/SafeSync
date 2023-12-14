import 'package:flutter/material.dart';
import 'package:safesync/ui/containers/form_support.dart';
import 'package:safesync/ui/containers/page_container.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PagesContainer(
        content: Column(
      children: [FormSupport()],
    ));
  }
}
