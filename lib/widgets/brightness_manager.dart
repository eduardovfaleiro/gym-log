// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:http/http.dart' as http;

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

    String theme = Config.getString('theme',
        defaultValue: PlatformDispatcher.instance.platformBrightness.name);
    _brightness = theme == 'light' ? Brightness.light : Brightness.dark;
  }

  void _toggleBrightness() async {
    setState(() {
      _brightness =
          _brightness == Brightness.light ? Brightness.dark : Brightness.light;
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

class CheckConnectionManager extends InheritedWidget {
  final bool hasConnection;
  final void Function() checkConnection;

  const CheckConnectionManager({
    super.key,
    required super.child,
    required this.hasConnection,
    required this.checkConnection,
  });

  static BrightnessManager of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BrightnessManager>()!;
  }

  @override
  bool updateShouldNotify(covariant CheckConnectionManager oldWidget) {
    return oldWidget.hasConnection != hasConnection;
  }
}

// class CheckConnectionController extends StatefulWidget {
//   final Widget child;

//   const CheckConnectionController({super.key, required this.child});

//   @override
//   State<CheckConnectionController> createState() =>
//       _CheckConnectionControllerState();
// }

// class _CheckConnectionControllerState extends State<CheckConnectionController> {
//   bool _hasInternetConnection = false;
//   bool _isTakingTooLong = false;

//   Future<void> _checkConnection() async {
//     // Check network connection first
//     final connectivityResult =
//         await Connectivity().checkConnectivity().timeout(const Duration(seconds: 3));
//     try {
//       if (connectivityResult.contains(ConnectivityResult.none)) {
//         setState(() {
//           _hasInternetConnection = false;
//         });
//         return;
//       }
//     } on TimeoutException {
//       setState(() {
//         _isTakingTooLong = true;
//       });
//     }

//     // Attempt an HTTP request to verify internet reachability
//     try {
//       // You can use any endpoint known to be up. Google's homepage is a common choice.
//       final response = await http
//           .get(Uri.parse('https://www.google.com'))
//           .timeout(const Duration(seconds: 3));
//       setState(() {
//         _hasInternetConnection = response.statusCode == 200;
//       });
//     } catch (e) {
//       setState(() {
//         _hasInternetConnection = false;
//         _isTakingTooLong = false;
//       });
//     } finally {
//       _isTakingTooLong = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CheckConnectionManager(
//       checkConnection: _checkConnection,
//       hasConnection: _hasInternetConnection,
//       child: PopScope(
//         canPop: !_isTakingTooLong,
//         child: _isTakingTooLong
//             ? Stack(
//                 children: [
//                   widget.child,
//                   Container(
//                     color: const Color.fromARGB(118, 0, 0, 0),
//                     height: double.infinity,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     child: const Column(
//                       children: [
//                         Text('Checando conexão à internet...'),
//                         CircularProgressIndicator(),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             : widget.child,
//       ),
//     );
//   }
// }

class CheckConnectionController extends StatefulWidget {
  final Widget child;

  const CheckConnectionController({super.key, required this.child});

  static final hasInternetConnectionNotifier = ValueNotifier(true);
  static final isTakingTooLong = ValueNotifier(false);

  static void _setConnection(bool hasConnection) {
    hasInternetConnectionNotifier.value = hasConnection;
  }

  static Future<bool> checkConnection() async {
    if (!hasInternetConnectionNotifier.value) return false;

    // Check network connection first
    try {
      final connectivityResult = await Connectivity()
          .checkConnectivity()
          .timeout(const Duration(seconds: 3));

      if (connectivityResult.contains(ConnectivityResult.none)) {
        _setConnection(false);
        return false;
      }
    } on TimeoutException {
      isTakingTooLong.value = true;
    }

    // Attempt an HTTP request to verify internet reachability
    try {
      // You can use any endpoint known to be up. Google's homepage is a common choice.
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 3));
      bool isConnected = response.statusCode == 200;
      _setConnection(isConnected);
      return isConnected;
    } catch (e) {
      _setConnection(false);
      isTakingTooLong.value = false;
      return false;
    } finally {
      isTakingTooLong.value = false;
    }
  }

  @override
  State<CheckConnectionController> createState() =>
      _CheckConnectionControllerState();
}

class _CheckConnectionControllerState extends State<CheckConnectionController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder(
        valueListenable: CheckConnectionController.isTakingTooLong,
        builder: (context, isTakingTooLong, _) {
          return PopScope(
            canPop: !isTakingTooLong,
            child: Stack(
              children: [
                widget.child,
                if (isTakingTooLong)
                  Container(
                    color: const Color.fromARGB(118, 0, 0, 0),
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Checando conexão à internet...'),
                        SizedBox(height: 12),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
