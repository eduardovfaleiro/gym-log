import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

Future<void> showPopup(
  BuildContext context, {
  required WidgetBuilder builder,
  double height = 40,
  double width = 150,
}) async {
  await showPopover(
    barrierColor: Colors.transparent,
    context: context,
    transitionDuration: Duration.zero,
    arrowHeight: 0,
    shadow: [],
    bodyBuilder: builder,
    backgroundColor: Colors.transparent,
    width: width,
    height: height,
    direction: PopoverDirection.bottom,
  );
}
