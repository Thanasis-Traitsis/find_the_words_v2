import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_router.dart';
import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final themeState = context.watch<ThemeCubit>().state;
        final langState = context.watch<LanguageCubit>().state;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: AppKeys.scaffoldMessengerKey,
          title: AppStrings.appName,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: langState.appLanguage.locale,
          supportedLocales: AppLanguage.langLocales,
          themeMode: themeState.themeMode,
          theme: AppTheme(AppColors.mainColors).getTheme(),
          darkTheme: AppTheme(AppColors.darkColors).getTheme(),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
