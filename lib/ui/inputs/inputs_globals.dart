import 'package:flutter/material.dart';

createUserName({bool show = true, required TextEditingController controller}) {
  return show
      ? Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(240, 250, 255, 255),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(176, 217, 255, 1),
                blurRadius: 30.0,
                spreadRadius: 0.1,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                hintText: 'Usuario...',
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
            onChanged: (text) {
              // ignore: avoid_print
              print(text);
            },
          ),
        )
      : const SizedBox();
}

createPasword({required TextEditingController controller}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(240, 250, 255, 255),
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(176, 217, 255, 1),
          blurRadius: 30.0,
          spreadRadius: 0.1,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        hintText: 'Contraseña...',
        hintStyle: const TextStyle(color: Color.fromRGBO(176, 199, 212, 1)),
        // icon: const Icon(Icons.password_outlined),
        suffixIcon: const Icon(Icons.no_encryption_gmailerrorred),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      obscureText: true,
      onChanged: (text) {
        // ignore: avoid_print
        print(text);
      },
    ),
  );
}

createEmail({required TextEditingController controller}) {
  return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 250, 255, 255),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(176, 217, 255, 1),
            blurRadius: 30.0,
            spreadRadius: 0.1,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          hintText: 'Correo...',
          hintStyle: const TextStyle(color: Color.fromRGBO(176, 199, 212, 1)),
          //  icon: const Icon(Icons.email_outlined),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (text) {
          // ignore: avoid_print
        },
      ));
}
