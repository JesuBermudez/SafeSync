import 'package:flutter/material.dart';
import 'package:safesync/services/login/login.dart';
import 'package:safesync/services/register/register.dart';

Widget simpleButton(Icon icon, String title, VoidCallback onTap) {
  return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        padding:
            const MaterialStatePropertyAll(EdgeInsets.fromLTRB(8, 10, 10, 10)),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        icon,
        const SizedBox(width: 5),
        Text(title, style: TextStyle(color: Colors.blueGrey.shade700))
      ]));
}

createButton(
    {required String text, VoidCallback? registerd, VoidCallback? logind}) {
  return ElevatedButton(
    onPressed: text == 'Registrarse'
        ? () {
            registerd!();
            register();
          }
        : () {
            logind!();
            login();
          },
    style: ButtonStyle(
      elevation: const MaterialStatePropertyAll(20),
      fixedSize: const MaterialStatePropertyAll(
        Size(300, 55),
      ),
      shadowColor: const MaterialStatePropertyAll(
        Color.fromARGB(125, 33, 72, 243),
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(90, 180, 251, 1),
            Color.fromRGBO(11, 97, 236, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    ),
  );
}

sendButton(
    {required Icon icon, required String text, required VoidCallback send}) {
  return ElevatedButton.icon(
    onPressed: send,
    icon: icon,
    label: Text(
      text,
      style: const TextStyle(fontSize: 18),
    ),
  );
}

Widget uploadFileButton({required VoidCallback onTap}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.deepPurple,
    ),
    child: const Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 40,
    ),
  );
}
