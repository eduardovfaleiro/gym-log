import 'package:flutter/material.dart';

Future<bool> showAsyncConfirmDialog(
  BuildContext context, {
  String title = '',
  String content = '',
  String confirm = 'Sim',
  String cancel = 'Não',
  Future<void> Function(BuildContext context)? onConfirm,
  // void Function()? onCancel,
}) async {
  bool canPop = true;

  return await showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return PopScope(
                  canPop: canPop,
                  child: AlertDialog(
                    title: Text(title),
                    content: content.isEmpty ? null : Text(content),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (!canPop) return;
                          Navigator.pop(context, false);
                        },
                        child: Text(cancel),
                      ),
                      TextButton(
                        onPressed: onConfirm != null
                            ? () async {
                                if (!canPop) return;
                                setStateDialog(() {
                                  canPop = false;
                                });
                                await onConfirm(context);
                                setStateDialog(() {
                                  canPop = true;
                                });
                              }
                            : () {
                                Navigator.pop(context, true);
                              },
                        child: Text(confirm),
                      ),
                    ],
                  ),
                );
              },
            );
          }) ??
      false;
}
