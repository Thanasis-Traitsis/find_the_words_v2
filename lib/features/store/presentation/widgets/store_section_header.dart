import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

abstract class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});
}

class StoreSectionHeader extends SectionHeader {
  final String header;
  final CustomIcons? _icon;
  final String? _textForIcon;
  final String? description;

  const StoreSectionHeader._({
    super.key,
    required this.header,
    CustomIcons? icon,
    String? textForIcon,
    this.description,
  }) : _icon = icon,
       _textForIcon = textForIcon;

  const StoreSectionHeader.withIcon({
    Key? key,
    required String header,
    required CustomIcons icon,
    String? description,
  }) : this._(key: key, header: header, icon: icon, description: description);

  const StoreSectionHeader.withText({
    Key? key,
    required String header,
    required String text,
    String? description,
  }) : this._(
         key: key,
         header: header,
         textForIcon: text,
         description: description,
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingM,
      children: [
        Row(
          spacing: AppSpacing.spacingM,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomText(header, textType: CustomTextType.bigHeading),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacingM),
              decoration: BoxDecoration(
                borderRadius: AppBorders.regularBorderRadius,
                border: Border.all(
                  width: AppBorders.smallBorderWidth,
                  color: context.colors.text,
                ),
              ),
              child: _icon != null
                  ? CustomSvgIcon(icon: _icon, color: context.colors.text)
                  : CustomText(
                      _textForIcon!,
                      textType: CustomTextType.smallHeading,
                    ),
            ),
          ],
        ),
        if (description != null)
          CustomText(description!, textType: CustomTextType.regularBody),
      ],
    );
  }
}
