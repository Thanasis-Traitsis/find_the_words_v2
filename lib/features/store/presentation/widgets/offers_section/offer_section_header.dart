import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section_header.dart';
import 'package:flutter/material.dart';

class OfferSectionHeader extends SectionHeader {
  const OfferSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreSectionHeader.withText(
      header: context.translate.xpMultiplierHeader,
      text: "x2",
      description:
          context.translate.xpMultiplierDescription(2),
    );
  }
}
