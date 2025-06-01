import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;

  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();
}

class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_isLoading) return;
        _isLoading = true;
        setState(() {});

        try {
          await widget.onPressed();
        } finally {
          _isLoading = false;
          if (context.mounted) {
            setState(() {});
          }
        }
      },
      child: SizedBox(
        height: 20,
        child: _isLoading
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              )
            : Center(child: widget.child),
      ),
    );
  }
}
