import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/dismiss_keyboard_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_bottomsheet.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/core/widgets/selected_option_button.dart';
import 'package:find_the_words/features/settings/presentation/settings_cubit/settings_cubit.dart';
import 'package:find_the_words/features/settings/presentation/widgets/bad_word_bottomsheet/bad_word_textfield.dart';
import 'package:find_the_words/features/settings/presentation/widgets/bottomsheet_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BadWordBottomsheet extends StatefulWidget {
  final List<String> previousStageWords;

  const BadWordBottomsheet({super.key, required this.previousStageWords});

  @override
  State<BadWordBottomsheet> createState() => _BadWordBottomsheetState();
}

class _BadWordBottomsheetState extends State<BadWordBottomsheet> {
  final TextEditingController _badWordController = TextEditingController();
  List<String> selectedWords = [];

  @override
  void dispose() {
    _badWordController.dispose();
    super.dispose();
  }

  void _toggleWordSelection(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.add(word);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedWords.clear();
      _badWordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScreen(
      child: CustomBottomsheet(
        headerTitle: context.translate.settingsItemReportBadWord,
        bottomsheetContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.spacingL,
          children: [
            CustomText(
              context.translate.settingsBadWordBottomsheetDescription,
              textType: CustomTextType.regularBody,
            ),
            if (widget.previousStageWords.isNotEmpty)
              BottomsheetSection(
                sectionTitle:
                    "${context.translate.settingsBadWordBottomsheetSectionTitleStageWords}:",
                sectionContent: Wrap(
                  spacing: AppSpacing.spacingM,
                  runSpacing: AppSpacing.spacingM,
                  children: List.generate(widget.previousStageWords.length, (
                    index,
                  ) {
                    return SelectedOptionButton(
                      content: widget.previousStageWords[index],
                      onTap: () => _toggleWordSelection(
                        widget.previousStageWords[index],
                      ),
                      isSelected: selectedWords.contains(
                        widget.previousStageWords[index],
                      ),
                      smallerContent: true,
                    );
                  }),
                ),
              ),
            BottomsheetSection(
              sectionTitle:
                  "${context.translate.settingsBadWordBottomsheetSectionTitleSelectedWord}:",
              sectionContent: BadWordTextfield(controller: _badWordController),
            ),
            Opacity(
              opacity: 0,
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.spacingM),
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
                    text:
                        context.translate.settingsBadWordBottomsheetButtonClear,
                    onPressed: _clearSelection,
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _badWordController,
                    builder: (context, value, child) {
                      return CustomPrimaryButton.regular(
                        isDisabled:
                            selectedWords.isEmpty && value.text.trim().isEmpty,
                        text: context
                            .translate
                            .settingsBadWordBottomsheetButtonSubmit,
                        onTap: () {
                          final cubit = context.read<SettingsCubit>();
                          final StringBuffer badWordsToSubmit = StringBuffer();

                          if (selectedWords.isNotEmpty) {
                            badWordsToSubmit.write(selectedWords.join(', '));
                          }

                          if (_badWordController.text.isNotEmpty) {
                            if (selectedWords.isNotEmpty) {
                              badWordsToSubmit.write(', ');
                            }
                            badWordsToSubmit.write(_badWordController.text);
                          }

                          Navigator.pop(context);

                          cubit.openEmail(
                            subject:
                                context.translate.settingsEmailSubjectBadWord,
                            body: 'Λέξεις: $badWordsToSubmit',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
