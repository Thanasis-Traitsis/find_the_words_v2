import 'package:find_the_words/app/splash_cubit/splash_state.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/config/theme/theme_cubit/theme_cubit.dart';
import 'package:find_the_words/config/version/version_cubit/version_cubit.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/app_bootstrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.minimal)
class SplashCubit extends Cubit<SplashState> {
  final AppBootstrapper bootstrapper;
  final VersionCubit versionCubit;
  final ThemeCubit themeCubit;
  final LanguageCubit languageCubit;

  SplashCubit({
    required this.bootstrapper,
    required this.versionCubit,
    required this.themeCubit,
    required this.languageCubit,
  }) : super(SplashLoading());

  Future<void> start() async {
    emit(SplashLoading());

    final themeLoad = themeCubit.loadTheme();
    final languageLoad = languageCubit.loadSelectedLang();

    await versionCubit.checkVersion();

    if (versionCubit.state.needsForceUpdate) {
      emit(SplashForceUpdate());
      return;
    }

    try {
      await Future.wait([themeLoad, languageLoad]);
      await bootstrapper.initialize();
      emit(SplashReady());
    } catch (e) {
      emit(SplashFailed(e.toString()));
    }
  }

  void retry() => start();
}
