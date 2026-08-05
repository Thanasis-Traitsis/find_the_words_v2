import 'package:find_the_words/app/splash_cubit/splash_state.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/core/services/app_bootstrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppBootstrapper bootstrapper;
  final VersionBloc versionBloc;

  SplashCubit({
    required this.bootstrapper,
    required this.versionBloc,
  }) : super(SplashLoading());

  Future<void> start() async {
    emit(SplashLoading());

    versionBloc.add(const CheckVersion());
    await versionBloc.stream.firstWhere((state) => !state.isLoading);

    if (versionBloc.state.needsForceUpdate) {
      emit(SplashForceUpdate());
      return;
    }

    try {
      await bootstrapper.initialize();
      emit(SplashReady());
    } catch (e) {
      emit(SplashFailed(e.toString()));
    }
  }

  void retry() => start();
}