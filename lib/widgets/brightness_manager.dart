// ignore_for_file: library_private_types_in_public_api

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_log/repositories/config.dart';

class BrightnessManager extends InheritedWidget {
  final Brightness brightness;
  final void Function() switchBrightness;

  const BrightnessManager({
    super.key,
    required this.brightness,
    required this.switchBrightness,
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
  late Brightness _brightness;

  @override
  void initState() {
    super.initState();

    String theme = Config.getString('theme', defaultValue: PlatformDispatcher.instance.platformBrightness.name);
    _brightness = theme == 'light' ? Brightness.light : Brightness.dark;
  }

  void _toggleBrightness() async {
    setState(() {
      _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
    await Config.setString('theme', _brightness.name);
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessManager(
      brightness: _brightness,
      switchBrightness: _toggleBrightness,
      child: widget.child,
    );
  }
}
