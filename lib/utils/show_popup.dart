import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

Future<void> showPopup(BuildContext context, {required WidgetBuilder builder}) async {
  await showPopover(
    barrierColor: Colors.transparent,
    context: context,
    transitionDuration: Duration.zero,
    arrowHeight: 0,
    shadow: [],
    bodyBuilder: builder,
    backgroundColor: Colors.transparent,
    width: 150,
    height: 40,
    direction: PopoverDirection.bottom,
  );
}
