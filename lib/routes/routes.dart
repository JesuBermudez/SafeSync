import 'package:flutter/material.dart';
import 'package:safesync/pages/login_page.dart';
import 'package:safesync/pages/register_page.dart';
import 'package:safesync/pages/start_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => StartPage(),
    '/login': (BuildContext context) => const LoginPage(),
    '/register': (BuildContext context) => const RegisterPage()
  };
}
