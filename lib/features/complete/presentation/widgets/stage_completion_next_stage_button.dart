import 'package:find_the_words/config/routes/args/stage_route_args.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageCompletionNextStageButton extends StatelessWidget {
  final UserEntity user;
  final bool isButtonAvailable;

  const StageCompletionNextStageButton({
    super.key,
    required this.user,
    required this.isButtonAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<StageBloc, StageState>(
      listener: (context, state) {
        if (state is StageReady && isButtonAvailable) {
          StageRouteArgs(
            stage: user.currentProgress.stage,
            level: user.currentProgress.level,
          ).pushReplacement();
        }
      },
      child: CustomPrimaryButton.large(
        text: context.translate.nextStageBtnText,
        onTap: () {
          getIt<StageBloc>().add(NextStageButtonPressed(user.currentProgress));
        },
        suffixIcon: CustomIcons.arrowRight,
        fullWidth: true,
      ),
    );
  }
}
