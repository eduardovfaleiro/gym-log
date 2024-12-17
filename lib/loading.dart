import 'package:flutter/material.dart';

class LoadingInheritedWidget extends InheritedWidget {
  final bool isLoading;
  final Function(bool) setLoading;

  const LoadingInheritedWidget({
    super.key,
    required this.isLoading,
    required this.setLoading,
    required super.child,
  });

  static LoadingInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoadingInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(LoadingInheritedWidget oldWidget) {
    return oldWidget.isLoading != isLoading;
  }
}

class LoadingWrapper extends StatefulWidget {
  final Widget child;

  const LoadingWrapper({super.key, required this.child});

  @override
  _LoadingWrapperState createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> {
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() => isLoading = value);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingInheritedWidget(
      isLoading: isLoading,
      setLoading: setLoading,
      child: Stack(
        children: [
          widget.child,
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
