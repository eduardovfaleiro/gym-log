import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String title, {
  String content = '',
  String confirm = 'Sim',
  String cancel = 'Não',
}) async {
  return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: content.isEmpty ? null : Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(confirm),
                ),
              ],
            );
          }) ??
      false;
}
