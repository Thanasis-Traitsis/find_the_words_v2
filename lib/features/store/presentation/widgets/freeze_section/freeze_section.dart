import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/features/store/presentation/widgets/freeze_section/freeze_section_header.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section.dart';
import 'package:flutter/material.dart';

class FreezeSection extends StatelessWidget {
  const FreezeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreSection(
      sectionHeader: const FreezeSectionHeader(),
      sectionContent: Container(
        alignment: Alignment.centerRight,
        child: CustomPrimaryButton.regular(
          text: "30",
          onTap: () {},
          suffixIcon: CustomIcons.star,
        ),
      ),
    );
  }
}
