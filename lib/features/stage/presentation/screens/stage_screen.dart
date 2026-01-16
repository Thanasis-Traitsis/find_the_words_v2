import 'dart:async';
import 'dart:math';

import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/sound_service.dart';
import 'package:find_the_words/core/utils/snackbar_helper.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/active_boost_tag.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/stage/domain/services/stage_xp_service.dart';
import 'package:find_the_words/features/stage/presentation/helpers/error_utils.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/circle_container_with_word.dart';
import 'package:find_the_words/features/stage/presentation/widgets/crossword/crossword_letter_box.dart';
import 'package:find_the_words/features/stage/presentation/widgets/extra_words/extra_word_box.dart';
import 'package:find_the_words/features/stage/presentation/widgets/freeze_stage_button.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_dialog.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_target_button.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/widgets/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StageScreen extends StatefulWidget {
  final int level;
  final int stage;
  const StageScreen({super.key, required this.stage, required this.level});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  bool _showOverlay = false;
  bool _blockWordCreation = false;
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _activeDescription = GlobalKey();
  final Map<int, GlobalKey> _gridKeys = {};
  List<GlobalKey> keysToHighlight = <GlobalKey>[];

  Timer? _timer;
  int _elapsedSeconds = 0;
  late final String _timerKey = AppKeys.timerKey(widget.stage);

  final _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _saveTimerToPrefs();
    _soundService.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt(_timerKey) ?? 0;

    if (savedTime == 0) {
      await prefs.setInt(_timerKey, savedTime);
    }

    setState(() {
      _elapsedSeconds = savedTime;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  Future<void> _saveTimerToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt(_timerKey);

    if (savedTime != null) {
      await prefs.setInt(_timerKey, _elapsedSeconds);
    }
  }

  Future<void> _clearTimerFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timerKey);
  }

  void _handleStageStateChange(BuildContext context, StageState state) {
    if (state is StageCompleted) {
      _handleStageCompletion(context, state);
    }

    if (state is StageInGameError) {
      SnackbarHelper.showErrorSnackbar(context, message: ErrorUtils.getErrorMessage(context, state.error));
    }

    if (state is StageActive) {
      _soundService.playResultSound(state);
    }
  }

  Future<void> _handleStageCompletion(
    BuildContext context,
    StageCompleted state,
  ) async {
    _timer?.cancel();
    await _clearTimerFromPrefs();
    await Future.delayed(const Duration(seconds: 1));

    final authCubit = getIt<AuthCubit>();
    final pointsCubit = getIt<PointsCubit>();
    final accountBoost = getIt<AccountBoostCubit>();
    final freezeCubit = getIt<FreezeCubit>();
    final authState = authCubit.state;

    if (authState is! AuthAuthenticated) return;

    final currentUser = authState.user;

    final stageResults = StageXPService.calculateStageResults(
      stage: state.stage,
      level: widget.level,
      stageNumber: widget.stage,
      timeInSeconds: _elapsedSeconds,
      currentProgress: currentUser.currentProgress.progress,
      xpMultiplier: accountBoost.currentMultiplier,
    );

    await authCubit.updateAfterStage(
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StageBloc, StageState>(
      listener: _handleStageStateChange,
      builder: (context, state) {
        if (state is! StageActive) {
          return CustomScreen(
            appBar: CustomAppbar.withUserPoints(
              isHomePage: false,
              suffixWidget: const ExtraWordsBox(),
              leadingIcon: CustomIcons.arrowLeft,
              title: context.translate.stageWithNumber(widget.stage),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final newPositions = state is StageInProgress
            ? state.newPositions
            : <int>[];

        final revealedPositions =
            state.stage.placementTracker.revealedPositions;

        final remainingPositions =
            state.stage.placementTracker.remainingPositions;

        return AbsorbPointer(
          absorbing: state is StageCompleted || _blockWordCreation,
          child: CustomScreen.withOverlay(
            showOverlay: _showOverlay,
            overlayWidgetKeys: keysToHighlight,
            onOverlayTap: () {
              setState(() {
                _showOverlay = false;
              });
            },
            appBar: CustomAppbar.withUserPoints(
              isHomePage: false,
              suffixWidget: const ExtraWordsBox(),
              leadingIcon: CustomIcons.arrowLeft,
              title: context.translate.stageWithNumber(widget.stage),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spacingL),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<FreezeCubit, FreezeState>(
                      builder: (context, freezeState) {
                        return Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: AppSpacing.spacingM,
                              bottom: AppSpacing.spacingM,
                              child: AnimatedOpacity(
                                duration: const Duration(seconds: 2),
                                opacity: freezeState.activeFreeze ? 1 : 0,
                                child: Container(
                                  padding: EdgeInsets.all(80),
                                  decoration: BoxDecoration(
                                    color: context.colors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                    border: Border.all(
                                      width: AppBorders.smallBorderWidth,
                                      color: context.colors.primary,
                                    ),
                                    borderRadius:
                                        AppBorders.regularBorderRadius,
                                  ),
                                  child: CustomSvgIcon(
                                    icon: CustomIcons.freeze,
                                    color: context.colors.primary.withValues(
                                      alpha: 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: AppSpacing.spacingM,
                              ),
                              child: Center(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: sqrt(
                                          state.stage.board.length,
                                        ).ceil(),
                                      ),
                                  itemCount: state.stage.board.length,
                                  itemBuilder: (context, index) {
                                    final isRevealed = revealedPositions
                                        .contains(index);
                                    final shouldAnimate = newPositions.contains(
                                      index,
                                    );

                                    if (remainingPositions.contains(index) &&
                                        !_gridKeys.containsKey(index)) {
                                      _gridKeys[index] = GlobalKey();
                                    }

                                    return Container(
                                      margin: state.stage.board.length < 10
                                          ? EdgeInsets.all(AppSpacing.spacingM)
                                          : state.stage.board.length < 80
                                          ? EdgeInsets.all(AppSpacing.spacingS)
                                          : EdgeInsets.all(
                                              AppSpacing.spacingXS,
                                            ),
                                      child: CrosswordLetterBox(
                                        key: _gridKeys[index],
                                        boardSize: state.stage.board.length,
                                        crosswordBoxItem:
                                            state.stage.board[index],
                                        isVisible: isRevealed,
                                        shouldAnimate: shouldAnimate,
                                        animationDelay:
                                            newPositions.indexOf(index) * 100,
                                        onTap: () {
                                          if (_showOverlay) {
                                            setState(() {
                                              _showOverlay = false;
                                            });
                                            getIt<StageBloc>().add(
                                              CrosswordLetterReveal(index),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      CircleContainerWithWord(
                        letters: state.stage.letters,
                        onWordFormationChange: (blockWord) {
                          setState(() {
                            _blockWordCreation = blockWord;
                          });
                        },
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: ActiveBoostTag(
                          withData: true,
                          isExpandable: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: AppSpacing.spacingM,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const HelpDialog(),
                          );
                        },
                        child: CustomSvgIcon(
                          icon: CustomIcons.info,
                          color: context.colors.text,
                          height: AppSizes.iconS,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: AppSpacing.spacingM,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FreezeStageButton(
                              onTap: () {
                                _timer?.cancel();
                                context.read<FreezeCubit>().activateFreeze();
                              },
                            ),
                            StageIconButton(
                              icon: CustomIcons.shuffle,
                              onTap: () {
                                setState(() {
                                  state.stage.letters.shuffle();
                                });
                              },
                            ),
                            StageIconButton(
                              icon: CustomIcons.magicWand,
                              onTap: () {
                                getIt<StageBloc>().add(
                                  CrosswordLetterReveal(null),
                                );
                              },
                            ),
                            HelpTargetButton(
                              descriptionKey: _activeDescription,
                              buttonKey: _buttonKey,
                              isActive: _showOverlay,
                              onTap: () {
                                setState(() {
                                  if (!_showOverlay) {
                                    keysToHighlight = [
                                      _buttonKey,
                                      _activeDescription,
                                      ...remainingPositions
                                          .where(
                                            (pos) => _gridKeys.containsKey(pos),
                                          )
                                          .map((pos) => _gridKeys[pos]!),
                                    ];
                                    _showOverlay = true;
                                  } else {
                                    _showOverlay = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
