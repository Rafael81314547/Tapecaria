import 'package:flutter/material.dart';

showSnackBar(
    {required BuildContext context,
    required String message,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor:
        isError ? Colors.red : const Color.fromARGB(255, 0, 241, 8),
    showCloseIcon: true,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
