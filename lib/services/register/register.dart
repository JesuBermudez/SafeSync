import 'package:flutter/material.dart';

import '../../models/user/user.dart';
import 'api_register.dart';

void register(
    TextEditingController usernameController,
    TextEditingController passwordController,
    TextEditingController emialController,
    BuildContext context) async {
  String userName = usernameController.text.trim();
  String password = passwordController.text.trim();
  String email = emialController.text.trim();

  if (userName == '' || password == '' || email == '') {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('¡ATENCIÓN!'),
        content: Text('Por favor, no deje campos vacios.'),
      ),
    );
    return;
  }

  User user = User(userName: userName, email: email, password: password);

  ApiService apiService = ApiService();

  String sucess = await apiService.registerUser(user);
  if (sucess == 'OK') {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Registrado'),
        content: Text('Fuiste registrado con exito'),
      ),
    );
    usernameController.clear();
    passwordController.clear();
    emialController.clear();
  } else {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error al ser registrado'),
        content: Text(sucess),
      ),
    );
    usernameController.clear();
    passwordController.clear();
    emialController.clear();
  }
}
