import 'package:find_the_words/config/ads/rewarded_cubit/rewarded_ad_cubit.dart';
import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/sound/cubit/sound_cubit.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/core/services/app_bootstrapper.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_ad_limit_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/settings/presentation/settings_cubit/settings_cubit.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:find_the_words/firebase_options.dart';
import 'package:find_the_words/splash_screen.dart';
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
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: AppKeys.testDeviceIds),
  );
  await setupMinimalServiceLocator();

  runApp(const MyAppLoader());
}

class MyAppLoader extends StatefulWidget {
  const MyAppLoader({super.key});

  @override
  State<MyAppLoader> createState() => _MyAppLoaderState();
}

class _MyAppLoaderState extends State<MyAppLoader> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AppBootstrapper().initialize();

      setState(() => _isReady = true);
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return MultiBlocProvider(
        providers: [BlocProvider.value(value: getIt<ThemeCubit>())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<VersionBloc>()),
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(
          value: ConnectivityCubit(getIt<ConnectivityService>()),
        ),
        BlocProvider.value(value: getIt<LanguageCubit>()),
        BlocProvider.value(value: getIt<RewardedAdCubit>()),
        BlocProvider.value(value: getIt<FreezeCubit>()),
        BlocProvider.value(value: getIt<PointsAdLimitCubit>()),
        BlocProvider.value(value: SoundCubit()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
        BlocProvider.value(value: getIt<AuthCubit>()),
        BlocProvider.value(value: getIt<PointsCubit>()),
        BlocProvider.value(value: getIt<AccountBoostCubit>()),
        BlocProvider.value(value: getIt<StageBloc>()),
        BlocProvider.value(value: getIt<TotalWordsBloc>()),
      ],
      child: const MyApp(),
    );
  }
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
