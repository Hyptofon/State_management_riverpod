import 'package:flutter/material.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void show(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
