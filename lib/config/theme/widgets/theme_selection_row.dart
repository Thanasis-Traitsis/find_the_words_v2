import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSelectionRow extends StatelessWidget {
  final ThemeMode theme;

  const ThemeSelectionRow({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();

        final rowTitle = switch (theme) {
          ThemeMode.light => context.translate.themeOptionLight,
          ThemeMode.dark => context.translate.themeOptionDark,
          ThemeMode.system => context.translate.themeOptionSystem,
        };

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            state.themeMode.name == theme.name
                ? SizedBox(
                    width: AppSizes.minTouchTarget,
                    child: CustomSvgIcon(
                      icon: CustomIcons.check,
                      color: context.colors.text,
                    ),
                  )
                : SizedBox(width: AppSizes.minTouchTarget),
            Expanded(
              child: InkWell(
                onTap: () async {
                  switch (theme) {
                    case ThemeMode.light:
                      await themeCubit.setLightTheme();
                    case ThemeMode.dark:
                      await themeCubit.setDarkTheme();
                    case ThemeMode.system:
                      await themeCubit.setSystemTheme();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacingL,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.colors.text,
                        width: AppBorders.smallBorderWidth,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(rowTitle, textType: CustomTextType.bigBody),
                      if (theme == ThemeMode.system) ...[
                        SizedBox(height: AppSpacing.spacingS),
                        CustomText(
                          context.translate.themeOptionSystemDescription,
                          textStyle: TextStyle(
                            fontSize: CustomTextType.regularBody.fontSize,
                            color: context.colors.text.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
