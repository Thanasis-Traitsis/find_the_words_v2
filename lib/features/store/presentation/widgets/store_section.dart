import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section_header.dart';
import 'package:flutter/material.dart';

class StoreSection extends StatelessWidget {
  final SectionHeader sectionHeader;
  final Widget sectionContent;

  const StoreSection({super.key, required this.sectionHeader, required this.sectionContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingL),
      decoration: BoxDecoration(
        borderRadius: AppBorders.bigBorderRadius,
        border: Border.all(
          width: AppBorders.smallBorderWidth,
          color: context.colors.black,
        ),
      ),
      child: Column(
        spacing: AppSpacing.spacingL,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader,
          sectionContent,
        ],
      ),
    );
  }
}
