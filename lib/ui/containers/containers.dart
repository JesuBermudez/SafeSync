import 'package:flutter/material.dart';

import '../buttons/buttons_elevations.dart';
import '../inputs/input_label.dart';
import '../inputs/inputs_globals.dart';
import '../inputs/redirection_login.dart';

class ContainerTitle extends StatelessWidget {
  const ContainerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Image.asset('assets/logo.png', height: 100),
          const Text(
            'SafeSync',
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ContainerInputs extends StatelessWidget {
  const ContainerInputs(
      {super.key,
      required this.screenHeight,
      required this.textContainer,
      this.labelUsername,
      required this.view});

  final double screenHeight;
  final String textContainer;
  final String? labelUsername;
  final bool view;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(50, 45, 50, screenHeight * 0.10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(8, 8),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            textContainer,
            style: const TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                shadows: [
                  Shadow(offset: Offset(1.0, 1.2), color: Colors.grey)
                ]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 27),
          LabelInput(label: labelUsername, input: createUserName(show: view)),
          LabelInput(label: 'Email', input: createEmail()),
          LabelInput(label: 'Password', input: createPasword()),
          const SizedBox(height: 40),
          createRedirection(
              text: '¿Ya tienes una cuenta?', textLink: 'Inicia sesión aquí'),
          const SizedBox(height: 40),
          createButton('Registrarse')
        ],
      ),
    );
  }
}
