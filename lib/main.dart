import 'package:find_the_words/config/sound/cubit/sound_cubit.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/settings/presentation/settings_cubit/settings_cubit.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:find_the_words/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/routes/app_router.dart';
import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupServiceLocator();
  await runMyApp();
}

Future<void> runMyApp() async {
  final themeCubit = ThemeCubit();
  final langCubit = getIt<LanguageCubit>();
  final soundCubit = SoundCubit();
  final settingsCubit = getIt<SettingsCubit>();

  await themeCubit.loadTheme();
  await langCubit.loadSelectedLang();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: langCubit),
        BlocProvider.value(value: soundCubit),
        BlocProvider.value(value: settingsCubit),
        BlocProvider.value(value: getIt<AuthCubit>()),
        BlocProvider.value(value: getIt<PointsCubit>()),
        BlocProvider.value(value: getIt<StageBloc>()),
        BlocProvider.value(value: getIt<TotalWordsBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

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
