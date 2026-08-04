import 'package:find_the_words/app/bootstrap_error_screen.dart';
import 'package:find_the_words/app/my_app.dart';
import 'package:find_the_words/config/ads/rewarded_cubit/rewarded_ad_cubit.dart';
import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/sound/cubit/sound_cubit.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
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
import 'package:find_the_words/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppLoader extends StatefulWidget {
  const MyAppLoader({super.key});

  @override
  State<MyAppLoader> createState() => _MyAppLoaderState();
}

enum _BootstrapStatus { loading, ready, failed }

class _MyAppLoaderState extends State<MyAppLoader> {
  _BootstrapStatus _status = _BootstrapStatus.loading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AppBootstrapper().initialize();

      setState(() => _status = _BootstrapStatus.ready);
    } catch (e) {
      debugPrint('Initialization error: $e');
      setState(() {
        _status = _BootstrapStatus.failed;
        _errorMessage = e.toString();
      });
    }
  }

  void _retry() {
    setState(() {
      _status = _BootstrapStatus.loading;
      _errorMessage = null;
    });
    _initializeApp();
  }

  List<BlocProvider> _splashProviders() {
    return [BlocProvider.value(value: getIt<ThemeCubit>())];
  }

  List<BlocProvider> _appProviders() {
    return [
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _BootstrapStatus.loading:
        return MultiBlocProvider(
          providers: _splashProviders(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      case _BootstrapStatus.failed:
        return MultiBlocProvider(
          providers: _splashProviders(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BootstrapErrorScreen(
              message: _errorMessage ?? '',
              onRetry: _retry,
            ),
          ),
        );
      case _BootstrapStatus.ready:
        return MultiBlocProvider(
          providers: _appProviders(),
          child: const MyApp(),
        );
    }
  }
}
