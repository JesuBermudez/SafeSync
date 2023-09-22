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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(82, 171, 249, 1),
            Color.fromRGBO(18, 104, 237, 1),
          ],
        )
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Image.asset('assets/logo-200.png', height: 80),
          const Text(
            'SafeSync',
            style: TextStyle(
                color: Colors.white,
                fontSize: 42.0,
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
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.125, MediaQuery.of(context).size.height * 0.075, MediaQuery.of(context).size.width * 0.125, screenHeight * 0.10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, 0.0),
          end: Alignment(1, 0.70),
          colors: <Color>[
            Color.fromRGBO(244, 250, 255, 1),
            Color.fromRGBO(176, 210, 255, 1),
          ]
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(38, 108, 209, 1),
            spreadRadius: 15,
            blurRadius: 14,
            offset: Offset(8, 8),
          ),
        ],
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
                color: Color.fromRGBO(47, 159, 255, 1),
                shadows: [
                  Shadow(offset: Offset(1, 2), color: Color.fromRGBO(114, 114, 114, 0.498), blurRadius: 3)
                ]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          LabelInput(label: labelUsername, input: createUserName(show: view)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          LabelInput(label: 'Correo', input: createEmail()),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          LabelInput(label: 'Contraseña', input: createPasword()),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          createRedirection(text: '¿Ya tienes una cuenta?', textLink: 'Inicia sesión aquí'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          createButton('Registrarse')
        ],
      ),
    );
  }
}
