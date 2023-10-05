import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';

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
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Get.height > 800
          ? Column(
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
            )
          : Container(
              padding: const EdgeInsets.only(bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            ),
    );
  }
}

// ignore: must_be_immutable
class ContainerInputs extends StatelessWidget {
  ContainerInputs({
    super.key,
    required this.textContainer,
    this.labelUsername,
    required this.view,
  });

  final String textContainer;
  final String? labelUsername;
  final bool view;

  User user = Get.find();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double content =
        view ? (Get.height * 0.175) + 433 : (Get.height * 0.175) + 379;

    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(
        Get.width * 0.10,
        Get.height * 0.06,
        Get.width * 0.10,
        0,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, 0.0),
          end: Alignment(1, 0.70),
          colors: <Color>[
            Color.fromRGBO(244, 250, 255, 1),
            Color.fromRGBO(176, 210, 255, 1),
          ],
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
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(47, 159, 255, 1),
              shadows: [
                Shadow(
                    offset: Offset(1, 2),
                    color: Color.fromRGBO(114, 114, 114, 0.498),
                    blurRadius: 5.5)
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: (Get.height - content) * 0.13),
          LabelInput(
            label: labelUsername,
            input: createUserName(show: view, controller: _usernameController),
          ),
          view
              ? SizedBox(height: (Get.height - content) * 0.05)
              : const SizedBox(),
          LabelInput(
            label: 'Correo',
            input: createEmail(controller: _emailController),
          ),
          view
              ? SizedBox(height: (Get.height - content) * 0.05)
              : SizedBox(height: (Get.height - content) * 0.08),
          LabelInput(
            label: 'Contraseña',
            input: createPasword(controller: _passwordController),
          ),
          SizedBox(height: (Get.height - content) * 0.08),
          createRedirection(
            text: view ? "¿Ya tienes una cuenta?" : "¿No tienes una cuenta?",
            textLink: view ? "Inicia sesión" : "Registrate",
          ),
          SizedBox(height: (Get.height - content) * 0.08),
          createButton(
              text: view ? 'Registrarse' : 'Entrar',
              registerd: () => view
                  ? user.dataUser(_emailController.text,
                      _passwordController.text, _usernameController.text)
                  : null,
              logind: () => view
                  ? null
                  : user.dataUser(
                      _emailController.text, _passwordController.text))
        ],
      ),
    );
  }
}
