import 'package:flutter/material.dart';

Future<void> showInfo(BuildContext context, {required String title, required String content}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
