import 'dart:math';

import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/stage/presentation/widgets/circle_container_with_word.dart';
import 'package:flutter/material.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/widgets/custom_appbar.dart';

class StageScreen extends StatefulWidget {
  final int stage;
  const StageScreen({super.key, required this.stage});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      appBar: CustomAppbar.withUserPoints(
        isHomePage: false,
        suffixWidget: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacingM),
              decoration: BoxDecoration(
                color: context.colors.lightBlue,
                borderRadius: AppBorders.bigBorderRadius,
                border: Border.all(
                  width: AppBorders.smallBorderWidth,
                  color: context.colors.darkBlue,
                ),
              ),
              child: CustomSvgIcon(icon: 'box', color: context.colors.darkBlue),
            ),
            Positioned(
              right: 34,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.spacingS),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: AppBorders.smallBorderRadius,
                ),
                child: CustomText(
                  '1',
                  textType: CustomTextType.smallTag,
                  isWhite: true,
                ),
              ),
            ),
          ],
        ),
        leadingIcon: 'arrow_left',
        title: context.translate.stageWithNumber(widget.stage),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.spacingL),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingM,
                ),
                child: Center(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: sqrt(144).ceil(),
                    ),
                    itemCount: 144,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ),
            ),
            const CircleContainerWithWord(),
          ],
        ),
      ),
    );
  }
}
