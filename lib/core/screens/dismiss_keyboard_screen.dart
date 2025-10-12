import 'package:flutter/material.dart';

class DismissKeyboardScreen extends StatelessWidget {
  final Widget child;

  const DismissKeyboardScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
