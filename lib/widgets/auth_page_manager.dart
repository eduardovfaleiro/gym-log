import 'package:flutter/material.dart';

enum AuthPage { register, login }

class AuthPageManager extends InheritedWidget {
  final AuthPage page;
  final void Function(AuthPage) updatePage;

  const AuthPageManager({
    super.key,
    required this.page,
    required this.updatePage,
    required super.child,
  });

  static AuthPageManager of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthPageManager>()!;
  }

  @override
  bool updateShouldNotify(AuthPageManager oldWidget) {
    return oldWidget.page != page;
  }
}

class AuthPageController extends StatefulWidget {
  final Widget child;

  const AuthPageController({super.key, required this.child});

  @override
  _AuthPageControllerState createState() => _AuthPageControllerState();
}

class _AuthPageControllerState extends State<AuthPageController> {
  AuthPage _currentPage = AuthPage.login;

  void _updatePage(AuthPage page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      page: _currentPage,
      updatePage: _updatePage,
      child: widget.child,
    );
  }
}
