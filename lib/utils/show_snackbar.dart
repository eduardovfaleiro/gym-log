import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(milliseconds: 2500),
    ),
  );
}
