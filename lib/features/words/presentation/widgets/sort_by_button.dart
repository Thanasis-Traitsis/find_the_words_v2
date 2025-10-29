import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SortByButton extends StatelessWidget {
  const SortByButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton(
        onPressed: () {},
        child: Row(
          spacing: AppSpacing.spacingM,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              context.translate.sortByAlphabetical,
              textType: CustomTextType.regularBody,
            ),
            CustomSvgIcon(
              icon: 'arrows_up_down',
              color: context.colors.text,
              height: AppSizes.iconS,
            ),
          ],
        ),
      ),
    );
  }
}
