import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BootstrapErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BootstrapErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

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
                      CustomText(
                        AppStrings.bootstrapErrorMessage,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        message,
                        textType: CustomTextType.smallBody,
                        textAlign: TextAlign.center,
                      ),
                      CustomPrimaryButton.large(
                        text: AppStrings.bootstrapErrorRetry,
                        onTap: onRetry,
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
