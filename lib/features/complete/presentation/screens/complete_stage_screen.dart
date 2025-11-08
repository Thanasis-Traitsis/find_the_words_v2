import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/app_spacing.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_completion_header.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_completion_next_stage_button.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_completion_widget_list.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_data_list_item.dart';
import 'package:find_the_words/features/complete/presentation/widgets/total_points_earned.dart';
import 'package:find_the_words/features/home/presentation/widgets/stage_and_level_card.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteStageScreen extends StatefulWidget {
  final StageResults stageResults;

  const CompleteStageScreen({super.key, required this.stageResults});

  @override
  State<CompleteStageScreen> createState() => _CompleteStageScreenState();
}

class _CompleteStageScreenState extends State<CompleteStageScreen> {
  final ScrollController _scrollController = ScrollController();
  double _bottomButtonOpacity = 0.0;
  double _inlineButtonOpacity = 1.0;
  final GlobalKey _inlineButtonKey = GlobalKey();
  final GlobalKey _floatingButtonKey = GlobalKey();
  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollable();
    });
  }

  void _checkIfScrollable() {
    if (_scrollController.hasClients) {
      final isScrollable = _scrollController.position.maxScrollExtent > 0;

      setState(() {
        _isScrollable = isScrollable;

        if (isScrollable) {
          _bottomButtonOpacity = 1.0;
          _inlineButtonOpacity = 0.0;
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isScrollable) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _inlineButtonKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? renderBoxFloating =
          _floatingButtonKey.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox == null) return;
      if (renderBoxFloating == null) return;

      final buttonPosition = renderBox.localToGlobal(Offset.zero);
      final buttonTop = buttonPosition.dy;

      final buttonPositionFloating = renderBoxFloating.localToGlobal(
        Offset.zero,
      );
      final buttonTopFloating = buttonPositionFloating.dy;

      final isButtonReachingFixedPosition = buttonTop <= buttonTopFloating;

      setState(() {
        if (isButtonReachingFixedPosition) {
          _bottomButtonOpacity = 0.0;
          _inlineButtonOpacity = 1.0;
        } else {
          _bottomButtonOpacity = 1.0;
          _inlineButtonOpacity = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        final currentUser = state.user;

        return CustomScreen(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: StageCompletionHeader(
                      stageNumber: widget.stageResults.stage.toString(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: AppSpacing.spacingXL),
                    sliver: SliverToBoxAdapter(
                      child: StageAndLevelCard(
                        profileStatus: currentUser.currentProgress,
                        withStage: false,
                        stageResults: widget.stageResults,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StageCompletionWidgetList(
                      headerTitle:
                          context.translate.completeStageStatisticsHeader,
                      widgetList: [
                        StageDataListItem.withDifficulty(
                          title: context.translate.completeStageDifficulty,
                          difficulty: widget.stageResults.difficulty,
                        ),
                        StageDataListItem(
                          title: context.translate.completeStageTimeSpent,
                          value: widget.stageResults.getFormattedTime(),
                        ),
                        StageDataListItem(
                          title: context.translate.completeStageCrosswordWords,
                          value: widget.stageResults.crosswordWords.toString(),
                        ),
                        StageDataListItem(
                          title: context.translate.completeStageExtraWords,
                          value: widget.stageResults.foundExtraWords.toString(),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StageCompletionWidgetList(
                      headerTitle: context.translate.completeStageRewardsHeader,
                      widgetList: [
                        StageDataListItem(
                          title:
                              context.translate.completeStageCompletionPoints,
                          value: widget.stageResults
                              .getPointsForStage()
                              .toString(),
                          isPoints: true,
                        ),
                        StageDataListItem(
                          title: context.translate.completeStageWordsPoints,
                          value: widget.stageResults
                              .getPointsForCrosswordWords()
                              .toString(),
                          isPoints: true,
                        ),
                        StageDataListItem(
                          title: context.translate.completeStageExtraWords,
                          value: widget.stageResults
                              .getPointsForExtraWords()
                              .toString(),
                          isPoints: true,
                        ),
                        if (widget.stageResults.newProgress == 100)
                          StageDataListItem(
                            title: context.translate.completeStageLevelUp,
                            value: widget.stageResults
                                .getPointsForLevelup()
                                .toString(),
                            isPoints: true,
                          ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: AppSpacing.spacingXL),
                    sliver: SliverToBoxAdapter(
                      child: TotalPointsEarned(
                        points: widget.stageResults.totalPointsForStage(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Opacity(
                      key: _inlineButtonKey,
                      opacity: _inlineButtonOpacity,
                      child: StageCompletionNextStageButton(
                        user: currentUser,
                        isButtonAvailable: _inlineButtonOpacity != 0.0,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          NavigationService.instance.pop();
                        },
                        child: CustomText(
                          context.translate.completeStageBackToHomeBtn,
                          textType: CustomTextType.regularBody,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: AppSpacing.spacingM,
                child: Opacity(
                  key: _floatingButtonKey,
                  opacity: _bottomButtonOpacity,
                  child: IgnorePointer(
                    ignoring: _bottomButtonOpacity == 0.0,
                    child: StageCompletionNextStageButton(
                      user: currentUser,
                      isButtonAvailable: _bottomButtonOpacity != 0.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
