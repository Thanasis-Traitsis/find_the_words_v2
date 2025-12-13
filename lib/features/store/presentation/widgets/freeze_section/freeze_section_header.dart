import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/store/presentation/widgets/store_section_header.dart';
import 'package:flutter/material.dart';

class FreezeSectionHeader extends SectionHeader {
  const FreezeSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreSectionHeader.withIcon(
      header: context.translate.freezeHeader,
      icon: CustomIcons.freeze,
      description: context.translate.freezeDescription,
    );
  }
}
