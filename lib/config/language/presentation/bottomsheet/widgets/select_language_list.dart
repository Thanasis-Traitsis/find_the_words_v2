import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/language/presentation/bottomsheet/widgets/select_language_item.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_filled_button.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
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
  final StorageService _storage = getIt<StorageService>();
  final AuthCubit _authCubit = getIt<AuthCubit>();

  @override
  void initState() {
    super.initState();

    final langState = context.read<LanguageCubit>().state;
    appLanguage = langState.appLanguage.code;
    selectedLangCode = langState.appLanguage.code;
  }

  void applyNewLanguage() {
    context.read<LanguageCubit>().setNewLanguage(selectedLangCode);
    _authCubit.onLanguageChanged(AppLanguage.fromCode(selectedLangCode));

    updateBottomsheetState();
  }

  void updateBottomsheetState() {
    setState(() {
      appLanguage = selectedLangCode;
    });
  }

  ProfileStatusModel _progressForLanguage(AppLanguage lang) {
    final user = _storage.getUser();
    if (user != null) {
      final progress = user.progressByLanguage[lang];
      if (progress != null) return progress;
    }

    return ProfileStatusModel.initial(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...AppLanguage.values.map((language) {
          final ProfileStatusModel langStatus = _progressForLanguage(language);

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
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingXL),
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
