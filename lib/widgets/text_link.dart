import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String data;
  final void Function() onTap;

  const TextLink(this.data, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(data, style: const TextStyle(color: Colors.blue)),
    );
  }
}
