import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/stage/presentation/widgets/stage_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FreezeStageButton extends StatelessWidget {
  final VoidCallback onTap;

  const FreezeStageButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FreezeCubit, FreezeState>(
      builder: (context, state) {
        if (state.totalFreezes > 0) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              StageIconButton(
                icon: CustomIcons.freeze,
                onTap: onTap,
              ),
              Positioned(
                left: -AppSizes.tinyHeight,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacingS),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: AppBorders.smallBorderRadius,
                  ),
                  child: CustomText(
                    state.totalFreezes.toString(),
                    textType: CustomTextType.smallTag,
                    isWhite: true,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
