import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/selected_option_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/filters_section.dart';
import 'package:flutter/material.dart';

class PreviousWordsFilterSection extends StatefulWidget {
  final List<String> prevWords;
  final Function(String) onQuickSearch;

  const PreviousWordsFilterSection({
    super.key,
    required this.prevWords,
    required this.onQuickSearch,
  });

  @override
  State<PreviousWordsFilterSection> createState() =>
      _PreviousWordsFilterSectionState();
}

class _PreviousWordsFilterSectionState
    extends State<PreviousWordsFilterSection> {
  List<String> selectedWords = [];

  void _toggleWordSelection(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.clear();
        selectedWords.add(word);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prevWords.isEmpty) return SizedBox.shrink();

    return Column(
      spacing: AppSpacing.spacingM,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FiltersSection(
          sectionTitle: "${context.translate.filtersSectionHeaderPreviousStageWords}:",
          sectionDescription: context.translate.filtersSectionDescriptionPreviousStageWords,
          sectionContent: Wrap(
            spacing: AppSpacing.spacingM,
            runSpacing: AppSpacing.spacingM,
            children: List.generate(widget.prevWords.length, (index) {
              return SelectedOptionButton(
                content: widget.prevWords[index],
                onTap: () => _toggleWordSelection(widget.prevWords[index]),
                isSelected: selectedWords.contains(widget.prevWords[index]),
                smallerContent: true,
              );
            }),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: CustomOutlineButton(
            text: context.translate.filtersSectionButtonQuickSearch,
            onPressed: () {
              widget.onQuickSearch(selectedWords[0]);
            },
            isDisabled: selectedWords.isEmpty,
          ),
        ),
      ],
    );
  }
}
