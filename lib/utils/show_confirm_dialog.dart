import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String title, {
  String content = '',
  String confirm = 'Sim',
  String cancel = 'Não',
  void Function(BuildContext context)? onConfirm,
  void Function()? onCancel,
  bool isDismissible = true,
  bool useRootNavigator = false,
}) async {
  return await showDialog(
          context: context,
          barrierDismissible: isDismissible,
          useRootNavigator: useRootNavigator,
          builder: (context) {
            return PopScope(
              canPop: isDismissible,
              child: AlertDialog(
                title: Text(title),
                content: content.isEmpty ? null : Text(content),
                actions: [
                  TextButton(
                    onPressed: onCancel ??
                        () {
                          Navigator.pop(context, false);
                        },
                    child: Text(cancel),
                  ),
                  TextButton(
                    onPressed: onConfirm != null
                        ? () => onConfirm(context)
                        : () {
                            Navigator.pop(context, true);
                          },
                    child: Text(confirm),
                  ),
                ],
              ),
            );
          }) ??
      false;
}
