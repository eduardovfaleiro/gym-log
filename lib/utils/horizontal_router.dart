import 'package:flutter/material.dart';
import 'package:gym_log/pages/view_imported_logs_page.dart';

class HorizontalRouter extends PageRouteBuilder {
  final Widget child;

  HorizontalRouter({required this.child})
      : super(
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}