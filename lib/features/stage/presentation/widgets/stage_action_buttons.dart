import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/breakpoint_utils.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_cubit.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_state.dart';
import 'package:find_the_words/features/stage/presentation/helpers/stage_controller.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:find_the_words/features/stage/presentation/widgets/freeze_stage_button.dart';
import 'package:find_the_words/features/stage/presentation/widgets/help/help_target_button.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageActionButtons extends StatelessWidget {
  final StageController controller;
  final StageActive state;
  final List<int> remainingPositions;

  const StageActionButtons({
    super.key,
    required this.controller,
    required this.state,
    required this.remainingPositions,
  });

  @override
  Widget build(BuildContext context) {
    final deviceOrientation = getDeviceOrientation(context);

    return Flex(
      direction: deviceOrientation == DeviceOrientation.portrait
          ? Axis.horizontal
          : Axis.vertical,
      spacing: AppSpacing.spacingM,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: controller.onInfoTap,
          child: CustomSvgIcon(
            icon: CustomIcons.info,
            color: context.colors.text,
            height: AppSizes.iconS,
          ),
        ),
        Expanded(
          child: Flex(
            direction: deviceOrientation == DeviceOrientation.portrait
                ? Axis.horizontal
                : Axis.vertical,
            spacing: AppSpacing.spacingM,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FreezeStageButton(onTap: controller.onFreezeTap),
              StageIconButton(
                icon: CustomIcons.shuffle,
                onTap: () => controller.onShuffleTap(state),
              ),
              StageIconButton(
                icon: CustomIcons.magicWand,
                onTap: controller.onMagicWandTap,
              ),
              BlocBuilder<HelpOverlayCubit, HelpOverlayState>(
                builder: (context, overlayState) {
                  return HelpTargetButton(
                    descriptionKey: controller.activeDescriptionKey,
                    buttonKey: controller.buttonKey,
                    isActive: overlayState.isVisible,
                    onTap: () => controller.onTargetTap(remainingPositions),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
