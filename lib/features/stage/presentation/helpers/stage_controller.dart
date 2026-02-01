import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/sound_service.dart';
import 'package:find_the_words/core/services/user_profile_service.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/stage/domain/services/stage_xp_service.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_cubit.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/stage_timer_cubit/stage_timer_cubit.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_dialog.dart';
import 'package:flutter/material.dart';

class StageController {
  final BuildContext context;
  final StageBloc stageBloc;
  final HelpOverlayCubit helpOverlayCubit;
  final StageTimerCubit timerCubit;
  final FreezeCubit freezeCubit;
  final SoundService soundService;

  // Keys for overlay
  final GlobalKey buttonKey = GlobalKey();
  final GlobalKey activeDescriptionKey = GlobalKey();
  final Map<int, GlobalKey> gridKeys = {};

  StageController({
    required this.context,
    required this.stageBloc,
    required this.helpOverlayCubit,
    required this.timerCubit,
    required this.freezeCubit,
    required this.soundService,
  });

  void onCrosswordTap(int index) {
    if (helpOverlayCubit.state.isVisible) {
      helpOverlayCubit.hide();
      stageBloc.add(CrosswordLetterReveal(index));
    }
  }

  void onInfoTap() {
    showDialog(context: context, builder: (context) => const HelpDialog());
  }

  void onFreezeTap() async {
    timerCubit.pause();
   final successfulFreeze = await freezeCubit.activateFreeze();

   if (successfulFreeze) stageBloc.add(StageFreezeActivated());
  }

  void onShuffleTap(StageActive state) {
    stageBloc.add(StageRefreshRequested());
  }

  void onMagicWandTap() {
    stageBloc.add(CrosswordLetterReveal(null));
  }

  void onTargetTap(List<int> remainingPositions) {
    final keys = [
      buttonKey,
      activeDescriptionKey,
      ...remainingPositions
          .where((pos) => gridKeys.containsKey(pos))
          .map((pos) => gridKeys[pos]!),
    ];
    helpOverlayCubit.toggle(keys);
  }

  Future<void> handleStageCompletion(
    StageCompleted state,
    int level,
    int stageNumber,
  ) async {
    await timerCubit.saveAndClear();
    await Future.delayed(const Duration(seconds: 1));

    final authCubit = getIt<AuthCubit>();
    final pointsCubit = getIt<PointsCubit>();
    final accountBoost = getIt<AccountBoostCubit>();
    final userProfileService = getIt<UserProfileService>();
    final authState = authCubit.state;

    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;

    final stageResults = StageXPService.calculateStageResults(
      stage: state.stage,
      level: level,
      stageNumber: stageNumber,
      timeInSeconds: timerCubit.state,
      currentProgress: currentUser.currentProgress.progress,
      xpMultiplier: accountBoost.currentMultiplier,
    );

    await userProfileService.updateAfterStage(
      stageResults.xpEarned,
      stageResults.newProgress,
    );

    await pointsCubit.addPoints(
      stageResults.totalPointsForStage(),
      reason: 'Stage completion',
    );

    accountBoost.decrementStage();

    if (freezeCubit.state.activeFreeze) {
      freezeCubit.deactivateFreeze();
    }

    if (!context.mounted) return;

    AppPages.complete.pushReplacement(extra: stageResults);
  }

  void dispose() {
    soundService.dispose();
  }
}
