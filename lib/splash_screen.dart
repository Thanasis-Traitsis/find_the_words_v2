import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: themeState.themeMode == ThemeMode.dark
              ? AppColors.darkColors.background
              : AppColors.mainColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    spacing: AppSpacing.spacingXL,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingXL,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/home_logo.svg',
                          height: AppSizes.logo,
                        ),
                      ),
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Color(0xffF7BA9D),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
