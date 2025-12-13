import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/game_instructions/presentation/widgets/bullet_text.dart';
import 'package:flutter/material.dart';

class RulesSection extends StatelessWidget {
  final String title;
  final CustomIcons icon;
  final List<String> content;
  final List<String>? subContent;

  const RulesSection({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.subContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingM),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.primary,
        ),
        borderRadius: AppBorders.regularBorderRadius,
      ),
      child: Column(
        spacing: AppSpacing.spacingM,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.spacingM,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSvgIcon(
                icon: icon,
                color: context.colors.primary,
                height: AppSizes.iconS,
              ),
              CustomText(
                title,
                textStyle: TextStyle(
                  fontSize: CustomTextType.smallHeading.fontSize,
                  fontWeight: CustomTextType.smallHeading.fontWeight,
                  color: context.colors.darkBlue,
                ),
              ),
            ],
          ),

          if (content.length > 1)
            ...List.generate(
              content.length,
              (index) => BulletText(content[index]),
            )
          else if (content.isNotEmpty)
            CustomText(content[0], textType: CustomTextType.regularBody),

          if (subContent != null) ...[
            Row(
              children: [
                SizedBox(width: AppSpacing.spacingL),
                Expanded(
                  child: Column(
                    spacing: AppSpacing.spacingM,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subContent!.length > 1)
                        ...List.generate(
                          subContent!.length,
                          (index) => BulletText(subContent![index]),
                        )
                      else if (subContent!.isNotEmpty)
                        CustomText(
                          subContent![0],
                          textType: CustomTextType.regularBody,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
