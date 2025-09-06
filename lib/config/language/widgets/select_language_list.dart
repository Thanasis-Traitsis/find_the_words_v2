import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/language/widgets/select_language_item.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_filled_button.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageList extends StatefulWidget {
  const SelectLanguageList({super.key});

  @override
  State<SelectLanguageList> createState() => _SelectLanguageListState();
}

class _SelectLanguageListState extends State<SelectLanguageList> {
  late String appLanguage;
  late String selectedLangCode;

  @override
  void initState() {
    final langState = context.read<LanguageCubit>().state;
    appLanguage = langState.appLanguage.code;
    selectedLangCode = langState.appLanguage.code;
    super.initState();
  }

  void applyNewLanguage() {
    context.read<LanguageCubit>().setNewLanguage(selectedLangCode);
    updateBottomsheetState();
  }

  void updateBottomsheetState() {
    setState(() {
      appLanguage = selectedLangCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...AppLanguage.values.map((language) {
          final ProfileStatusModel langStatus = getIt<StorageService>()
              .getProgressForLanguage(language);

          return SelectLanguageItem(
            isSelected: selectedLangCode == language.code,
            langStatus: langStatus,
            lang: language,
            onTap: () {
              setState(() {
                if (selectedLangCode != language.code) {
                  selectedLangCode = language.code;
                }
              });
            },
          );
        }),
        Align(
          alignment: Alignment.bottomRight,
          child: CustomFilledButton(
            text: context.translate.languageBottomsheetUpdateBtn,
            onPressed: applyNewLanguage,
            fullWidth: false,
            withIcon: false,
            isDisabled: appLanguage == selectedLangCode,
          ),
        ),
      ],
    );
  }
}
