// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class BrightnessManager extends InheritedWidget {
  final Brightness brightness;
  final void Function(Brightness) updateBrightness;

  const BrightnessManager({
    super.key,
    required this.brightness,
    required this.updateBrightness,
    required super.child,
  });

  static BrightnessManager of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BrightnessManager>()!;
  }

  @override
  bool updateShouldNotify(BrightnessManager oldWidget) {
    return oldWidget.brightness != brightness;
  }
}

class BrightnessController extends StatefulWidget {
  final Widget child;

  const BrightnessController({super.key, required this.child});

  @override
  _BrightnessControllerState createState() => _BrightnessControllerState();
}

class _BrightnessControllerState extends State<BrightnessController> {
  Brightness _brightness = Brightness.light;

  void _toggleBrightness(Brightness brightness) {
    setState(() {
      _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessManager(
      brightness: _brightness,
      updateBrightness: _toggleBrightness,
      child: widget.child,
    );
  }
}
