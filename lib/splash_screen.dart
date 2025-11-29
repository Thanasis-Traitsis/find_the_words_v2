import 'package:flutter/material.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/features/home/presentation/widgets/logo_container.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.spacingXL,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoContainer(),
              LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xffF7BA9D),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
