import 'package:flutter/material.dart';

createUserName({bool show = true}) {
  return show
      ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              labelText: 'Username',
            ),
            onChanged: (text) {
              // ignore: avoid_print
              print(text);
            },
          ),
        )
      : const SizedBox();
}

createPasword() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 5.0,
          spreadRadius: 0.0,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: 'Password',
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

createEmail() {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          labelText: 'Email',
          suffixText: '@gmail.com',
          //  icon: const Icon(Icons.email_outlined),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (text) {
          // ignore: avoid_print
          print(text);
        },
      ));
}
