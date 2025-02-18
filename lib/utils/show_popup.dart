import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

Future<void> showPopup(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
  double height = 40,
  double width = 150,
  double xOffset = 0,
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
    contentDxOffset: xOffset,
  );
}
