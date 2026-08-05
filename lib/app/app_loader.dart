import 'package:find_the_words/app/bootstrap_error_screen.dart';
import 'package:find_the_words/app/my_app.dart';
import 'package:find_the_words/app/splash_cubit/splash_cubit.dart';
import 'package:find_the_words/app/splash_cubit/splash_state.dart';
import 'package:find_the_words/config/ads/rewarded_cubit/rewarded_ad_cubit.dart';
import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/sound/cubit/sound_cubit.dart';
import 'package:find_the_words/config/theme/app_colors.dart';
import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/config/version/force_update_screen.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
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
import 'package:provider/single_child_widget.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<LanguageCubit>()),
        BlocProvider(create: (_) => getIt<SplashCubit>()..start()),
      ],
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          if (state is SplashReady) {
            return MultiBlocProvider(
              providers: _fullAppProviders(),
              child: const MyApp(),
            );
          }
          return _SplashShell(state: state);
        },
      ),
    );
  }

  List<SingleChildWidget> _fullAppProviders() {
    return [
      BlocProvider.value(value: getIt<VersionBloc>()),
      BlocProvider.value(value: getIt<ConnectivityCubit>()),
      BlocProvider.value(value: getIt<RewardedAdCubit>()),
      BlocProvider.value(value: getIt<FreezeCubit>()),
      BlocProvider.value(value: getIt<PointsAdLimitCubit>()),
      BlocProvider.value(value: getIt<SoundCubit>()),
      BlocProvider.value(value: getIt<SettingsCubit>()),
      BlocProvider.value(value: getIt<AuthCubit>()),
      BlocProvider.value(value: getIt<PointsCubit>()),
      BlocProvider.value(value: getIt<AccountBoostCubit>()),
      BlocProvider.value(value: getIt<StageBloc>()),
      BlocProvider.value(value: getIt<TotalWordsBloc>()),
    ];
  }
}

class _SplashShell extends StatelessWidget {
  final SplashState state;
  const _SplashShell({required this.state});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      theme: AppTheme(AppColors.mainColors).getTheme(),
      darkTheme: AppTheme(AppColors.darkColors).getTheme(),
      home: switch (state) {
        SplashLoading() => const SplashScreen(),
        SplashForceUpdate() => const ForceUpdateScreen(),
        SplashFailed(:final message) => BootstrapErrorScreen(
            message: message,
            onRetry: () => context.read<SplashCubit>().retry(),
          ),
        SplashReady() => const SizedBox.shrink(),
      },
    );
  }
}