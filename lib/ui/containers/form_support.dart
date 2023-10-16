import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/support/support.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/inputs/inputs_globals.dart';
import 'package:safesync/ui/labels/title_label.dart';

// ignore: must_be_immutable
class FormSupport extends StatelessWidget {
  FormSupport({super.key});
  Support support = Get.find<Support>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleLabel('Soporte'),
        const SizedBox(height: 50),
        const Text('De:', style: TextStyle(fontWeight: FontWeight.w700)),
        createSendEmail(controller: _emailController),
        const SizedBox(height: 20),
        const Text('Asunto:', style: TextStyle(fontWeight: FontWeight.w700)),
        createSubject(controller: _subjectController),
        const SizedBox(height: 20),
        const Text('Mensaje:', style: TextStyle(fontWeight: FontWeight.w700)),
        createTextArea(controller: _messageController),
        SizedBox(height: Get.height * 0.1),
        sendButton(send: () {
          support.dataEmail(
            emailUser: _emailController.text,
            subjectUser: _subjectController.text,
            messageUser: _messageController.text,
          );
          _emailController.text = '';
          _subjectController.text = '';
          _messageController.text = '';
        })
      ],
    );
  }
}
