import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({
    super.key,
    this.appBar,
    required this.child,
    this.withPadding = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final bool withPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: null,
      body: SafeArea(
        child: Padding(
          padding: withPadding
              ? EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding)
              : EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
