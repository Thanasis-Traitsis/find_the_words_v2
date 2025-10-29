import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/game_instructions/presentation/widgets/bullet_text.dart';
import 'package:flutter/material.dart';

class RulesSection extends StatelessWidget {
  final String title;
  final List<String> content;
  final List<String>? subContent;

  const RulesSection({
    super.key,
    required this.title,
    required this.content,
    this.subContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingM,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacingM),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: AppBorders.smallBorderWidth,
                color: context.colors.text.withValues(alpha: 0.6),
              )
            )
          ),
          child: CustomText(title, textType: CustomTextType.regularHeading)),

        if (content.length > 1)
          ...List.generate(
            content.length,
            (index) => BulletText(content[index]),
          )
        else if (content.isNotEmpty)
          CustomText(content[0], textType: CustomTextType.regularBody),

        if (subContent != null) ...[
          const SizedBox(height: AppSpacing.spacingS),
          Row(
            children: [
              SizedBox(width: AppSpacing.spacingXL),
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
    );
  }
}
