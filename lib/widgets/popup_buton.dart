// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final String label;
  final void Function() onTap;

  const PopupButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Center(child: Text(label)),
      ),
    );
  }
}

class PopupIconButton extends StatelessWidget {
  final Widget? icon;
  final Widget child;
  final void Function() onTap;

  const PopupIconButton({super.key, required this.child, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PopupCustomButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: icon,
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class PopupCustomButton extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const PopupCustomButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PopupContainer(child: child),
    );
  }
}

class PopupContainer extends StatelessWidget {
  final Widget child;

  const PopupContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: child,
    );
  }
}
