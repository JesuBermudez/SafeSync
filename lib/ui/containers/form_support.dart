import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/support/support.dart';
import 'package:safesync/ui/buttons/buttons_elevations.dart';
import 'package:safesync/ui/inputs/inputs_globals.dart';
import 'package:safesync/ui/labels/title_label.dart';
import 'package:safesync/services/support/support.dart';

// ignore: must_be_immutable
class FormSupport extends StatelessWidget {
  FormSupport({super.key});
  Support supportController = Get.find<Support>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        titleLabel('Soporte', fontSize: 35),
        const SizedBox(height: 20),
        const Text('De:', style: TextStyle(fontWeight: FontWeight.w700)),
        createSendEmail(controller: _emailController),
        const SizedBox(height: 20),
        const Text('Asunto:', style: TextStyle(fontWeight: FontWeight.w700)),
        createSubject(controller: _subjectController),
        const SizedBox(height: 20),
        const Text('Mensaje:', style: TextStyle(fontWeight: FontWeight.w700)),
        createTextArea(controller: _messageController),
        SizedBox(height: Get.height * 0.06),
        SizedBox(
            width: double.infinity,
            height: 50,
            child: sendButton(
                icon: const Icon(Icons.send_rounded),
                text: "Enviar",
                send: () {
                  supportController.dataEmail(
                    emailUser: _emailController.text,
                    subjectUser: _subjectController.text,
                    messageUser: _messageController.text,
                  );
                  _emailController.text = '';
                  _subjectController.text = '';
                  _messageController.text = '';

                  support();
                })),
        SizedBox(height: Get.height * 0.065),
        const Text(
          "Valoramos mucho tu opinión y estamos aquí para ayudarte. ",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromARGB(255, 96, 120, 139),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}
