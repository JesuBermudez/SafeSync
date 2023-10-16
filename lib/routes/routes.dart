import 'package:flutter/material.dart';
import 'package:safesync/pages/app_screen.dart';
import 'package:safesync/pages/login_page.dart';
import 'package:safesync/pages/page_support.dart';
import 'package:safesync/pages/register_page.dart';
import 'package:safesync/pages/start_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{
    '/app': (BuildContext context) => AppScreen(),
    '/startpage': (BuildContext context) => StartPage(),
    '/login': (BuildContext context) => LoginPage(),
    '/register': (BuildContext context) => const RegisterPage(),
    '/support': (BuildContext context) => const SupportPage()
  };
}
