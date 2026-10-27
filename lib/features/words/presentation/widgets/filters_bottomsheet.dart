import 'package:find_the_words/core/widgets/info_container.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/words/domain/models/word_filters.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:find_the_words/core/widgets/selected_option_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/filters_section.dart';
import 'package:find_the_words/features/words/presentation/widgets/previous_words_filter_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersBottomsheet extends StatefulWidget {
  final WordFilters filters;
  final List<String> prevWords;

  const FiltersBottomsheet({
    super.key,
    required this.filters,
    required this.prevWords,
  });

  @override
  State<FiltersBottomsheet> createState() => _FiltersBottomsheetState();
}

class _FiltersBottomsheetState extends State<FiltersBottomsheet> {
  List<String> selectedLetters = [];
  RangeValues wordLengthValue = const RangeValues(3, 12);
  late WordFilters newFilters;

  @override
  void initState() {
    super.initState();

    newFilters = widget.filters;

    selectedLetters = widget.filters.selectedLetters.toList();

    final minLength = widget.filters.minWordLength.toDouble();
    final maxLength = widget.filters.maxWordLength.toDouble();

    wordLengthValue = RangeValues(minLength, maxLength);
  }

  void _toggleLetter(String letter) {
    setState(() {
      if (selectedLetters.contains(letter)) {
        selectedLetters.remove(letter);
      } else {
        selectedLetters.add(letter);
      }
    });
  }

  void _clearLetters() {
    setState(() {
      selectedLetters.clear();
    });
  }

  void _applyFilters() {
    final bool hasStaringLengths =
        wordLengthValue.start.round() == 3 && wordLengthValue.end.round() == 12;
    final Set<int> wordLength = hasStaringLengths
        ? {}
        : {wordLengthValue.start.round(), wordLengthValue.end.round()};

    final updatedFilters = newFilters.copyWith(
      selectedLetters: Set.from(selectedLetters),
      selectedWordLengths: wordLength,
    );

    getIt<TotalWordsBloc>().add(UpdateFiltersEvent(updatedFilters));
    NavigationService.instance.pop();
  }

  void _clearAllFilters() {
    setState(() {
      selectedLetters.clear();
      wordLengthValue = const RangeValues(3, 12);
    });
    getIt<TotalWordsBloc>().add(ResetFiltersEvent());
    NavigationService.instance.pop();
  }

  bool applyButtonDisable() {
    return listEquals(
          selectedLetters,
          widget.filters.selectedLetters.toList(),
        ) &&
        wordLengthValue ==
            RangeValues(
              newFilters.minWordLength.toDouble(),
              newFilters.maxWordLength.toDouble(),
            );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      headerTitle: context.translate.filtersHeaderTitle,
      bottomsheetContent: Column(
        spacing: AppSpacing.spacingL,
        children: [
          FiltersSection(
            sectionTitle: context.translate.filtersSectionHeaderAllLetters,
            sectionContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoContainer.small(infoText: context.translate.filterInfoText),
                Row(
                  spacing: AppSpacing.spacingM,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: selectedLetters.isEmpty,
                      onChanged: null,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: CustomText(
                        context.translate.filtersSectionContentShowAllLetters,
                        textType: CustomTextType.regularBody,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FiltersSection(
            sectionTitle: context.translate.filtersSectionHeaderSelectedLetters,
            sectionDescription: context.translate.filtersSectionDescriptionPreviousStageWords,
            sectionContent: Column(
              spacing: AppSpacing.spacingM,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.spacingM,
                  runSpacing: AppSpacing.spacingM,
                  children: List.generate(
                    newFilters.lettersFromSelectedLang.length,
                    (index) {
                      final letter = newFilters.lettersFromSelectedLang[index];
                      return SelectedOptionButton(
                        content: letter,
                        onTap: () => _toggleLetter(letter),
                        isSelected: selectedLetters.contains(letter),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: CustomOutlineButton(
                    text: context.translate.filtersSectionButtonClearLetters,
                    onPressed: _clearLetters,
                    isDisabled: selectedLetters.isEmpty,
                  ),
                ),
              ],
            ),
          ),
          FiltersSection(
            sectionTitle: context.translate.filtersSectionHeaderWordLength,
            sectionContent: Column(
              spacing: AppSpacing.spacingL,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  context.translate.filtersSectionContentWordLength(
                    wordLengthValue.start.round(),
                    wordLengthValue.end.round(),
                  ),
                  textType: CustomTextType.regularBody,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: RangeSlider(
                    values: wordLengthValue,
                    onChanged: (newValue) {
                      setState(() {
                        wordLengthValue = newValue;
                      });
                    },
                    min: 3,
                    max: 12,
                    divisions: 9,
                    labels: RangeLabels(
                      wordLengthValue.start.round().toString(),
                      wordLengthValue.end.round().toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PreviousWordsFilterSection(
            prevWords: widget.prevWords,
            onQuickSearch: (word) {
              context.read<TotalWordsBloc>().add(SearchWordsEvent(word));
              _clearAllFilters();
              FocusScope.of(context).unfocus();
            },
          ),
          Opacity(
            opacity: 0.0,
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.spacingL),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingL,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: AppBorders.smallBorderWidth,
                    color: context.colors.black,
                  ),
                ),
              ),
              alignment: Alignment.bottomRight,
              child: CustomPrimaryButton.regular(
                text: context.translate.filtersButtonApply,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
      bottomFixedWidget: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        decoration: BoxDecoration(
          color: context.colors.background,
          border: Border(
            top: BorderSide(
              width: AppBorders.smallBorderWidth,
              color: context.colors.black,
            ),
          ),
        ),
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Row(
            spacing: AppSpacing.spacingM,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: CustomOutlineButton(
                  text: context.translate.filtersButtonClean,
                  onPressed: _clearAllFilters,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: CustomPrimaryButton.regular(
                  isDisabled: applyButtonDisable(),
                  text: context.translate.filtersButtonApply,
                  onTap: _applyFilters,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
