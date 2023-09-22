import 'package:flutter/material.dart';
import 'package:safesync/pages/register_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{'/': (BuildContext context) => const RegisterPage()};
}
