import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/lang_bottomsheet.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppBorders.regularBorderRadius,
        onTap: () {
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return LangBottomsheet();
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppBorders.regularBorderRadius,
            border: Border.all(
              width: AppBorders.smallBorderWidth,
              color: context.colors.black,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacingM),
          child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return Row(
                spacing: AppSpacing.spacingM,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: AppSizes.iconS + 4,
                    height: AppSizes.iconS,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/${state.appLanguage.flag}',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: AppBorders.smallBorderRadius,
                    ),
                  ),
                  CustomText(
                    state.appLanguage.code.toUpperCase(),
                    textType: CustomTextType.smallTag,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
