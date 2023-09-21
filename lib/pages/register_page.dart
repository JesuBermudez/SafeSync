import 'package:flutter/material.dart';

import '../ui/inputs/input_label.dart';
import '../ui/inputs/redirection_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          //Fondo azul con logo y nombre de la app
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: Container(
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
            ),
          ),

          //Contenedor de los imputs
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 200,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 45, 50, screenHeight * 0.30),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Registrarse',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          shadows: [
                            Shadow(offset: Offset(1.0, 1.2), color: Colors.grey)
                          ]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LabelInput(label: 'User Name', input: createUserName()),
                    LabelInput(label: 'Email', input: createEmail()),
                    LabelInput(label: 'Password', input: createPasword()),
                    const SizedBox(height: 40),
                    createRedirection(
                        text: '¿Ya tienes una cuenta?',
                        textLink: 'Inicia sesión aquí'),
                    const SizedBox(height: 40),
                    createButtonRegister()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  createButtonRegister() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(20),
          fixedSize: const MaterialStatePropertyAll(Size(200, 45)),
          shadowColor: const MaterialStatePropertyAll(Colors.blue),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)))),
      child: const Text(
        'Registrarse',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  createUserName() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        labelText: 'Username',
        icon: const Icon(Icons.person),
      ),
      onChanged: (text) {
        // ignore: avoid_print
        print(text);
      },
    );
  }

  createPasword() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: 'Password',
        icon: const Icon(Icons.password_outlined),
        suffixIcon: const Icon(Icons.no_encryption_gmailerrorred),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      obscureText: true,
      onChanged: (text) {
        // ignore: avoid_print
        print(text);
      },
    );
  }

  createEmail() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: 'Email',
        suffixText: '@gmail.com',
        icon: const Icon(Icons.email_outlined),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (text) {
        // ignore: avoid_print
        print(text);
      },
    );
  }
}
