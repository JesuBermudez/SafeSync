import 'package:flutter/material.dart';

createRedirection({required String text, required String textLink}) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Text(
      text,
      style: const TextStyle(
        fontSize: 16.0,
      ),
    ),
    const SizedBox(height: 10.0),
    GestureDetector(
      onTap: () {
        // pantalla para iniciar sesión
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      },
      child: Text(
        textLink,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    )
  ]);
}
