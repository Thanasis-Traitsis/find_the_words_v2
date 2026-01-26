import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/sound_service.dart';
import 'package:find_the_words/core/utils/breakpoint_utils.dart';
import 'package:find_the_words/core/utils/snackbar_helper.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_appbar.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_cubit.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_state.dart';
import 'package:find_the_words/features/stage/presentation/helpers/error_utils.dart';
import 'package:find_the_words/features/stage/presentation/helpers/stage_controller.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/stage_timer_cubit/stage_timer_cubit.dart';
import 'package:find_the_words/features/stage/presentation/widgets/extra_words/extra_word_box.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_landscape_layout.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_portrait_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageScreen extends StatefulWidget {
  final int level;
  final int stage;

  const StageScreen({super.key, required this.stage, required this.level});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  late final StageController _controller;
  bool _blockWordCreation = false;

  @override
  void initState() {
    super.initState();
    _controller = StageController(
      context: context,
      stageBloc: getIt<StageBloc>(),
      helpOverlayCubit: context.read<HelpOverlayCubit>(),
      timerCubit: context.read<StageTimerCubit>(),
      freezeCubit: context.read<FreezeCubit>(),
      soundService: SoundService(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStageStateChange(BuildContext context, StageState state) {
    if (state is StageCompleted) {
      _controller.handleStageCompletion(state, widget.level, widget.stage);
    }

    if (state is StageInGameError) {
      SnackbarHelper.showErrorSnackbar(
        context,
        message: ErrorUtils.getErrorMessage(context, state.error),
      );
    }

    if (state is StageActive) {
      _controller.soundService.playResultSound(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceOrientation = getDeviceOrientation(context);

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

        return BlocBuilder<HelpOverlayCubit, HelpOverlayState>(
          builder: (context, overlayState) {
            return AbsorbPointer(
              absorbing: state is StageCompleted || _blockWordCreation,
              child: CustomScreen.withOverlay(
                showOverlay: overlayState.isVisible,
                overlayWidgetKeys: overlayState.keysToHighlight,
                onOverlayTap: () => _controller.helpOverlayCubit.hide(),
                appBar: CustomAppbar.withUserPoints(
                  isHomePage: false,
                  suffixWidget: const ExtraWordsBox(),
                  leadingIcon: CustomIcons.arrowLeft,
                  title: context.translate.stageWithNumber(widget.stage),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacingL),
                  child: deviceOrientation == DeviceOrientation.portrait
                      ? StagePortraitLayout(
                          state: state,
                          controller: _controller,
                          blockWordCreation: _blockWordCreation,
                          onWordFormationChange: (block) {
                            setState(() => _blockWordCreation = block);
                          },
                        )
                      : StageLandscapeLayout(
                          state: state,
                          controller: _controller,
                          blockWordCreation: _blockWordCreation,
                          onWordFormationChange: (block) {
                            setState(() => _blockWordCreation = block);
                          },
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
