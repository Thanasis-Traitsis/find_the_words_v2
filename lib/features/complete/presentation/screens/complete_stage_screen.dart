import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/app_spacing.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_filled_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_completion_section_header.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_data_list_item.dart';
import 'package:find_the_words/features/complete/presentation/widgets/total_points_earned.dart';
import 'package:find_the_words/features/home/presentation/widgets/stage_and_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteStageScreen extends StatelessWidget {
  const CompleteStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.spacingL,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: AppSpacing.spacingS,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: AppSpacing.spacingM,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        '38',
                        textType: CustomTextType.bigHeading,
                        isItalic: true,
                      ),
                      CustomText(
                        'Στάδιο',
                        textType: CustomTextType.regularHeading,
                        isItalic: true,
                      ),
                    ],
                  ),
                  CustomText(
                    'Ολοκληρώθηκε!',
                    textType: CustomTextType.regularHeading,
                  ),
                ],
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is! AuthAuthenticated) {
                    return const SizedBox.shrink();
                  }
                  return StageAndLevelCard(
                    profileStatus: state.user.currentProgress,
                    withStage: false,
                    xpEarned: 10,
                  );
                },
              ),
              StageCompletionSectionHeader(header: 'Στατιστικά Σταδίου'),
              StageDataListItem(title: 'Δυσκολία σταδίου', value: 3),
              StageDataListItem(title: 'Χρόνος επίλυσης', value: 3),
              StageDataListItem(title: 'Λέξεις Σταδίου', value: 3),
              StageDataListItem(title: 'Έξτρα λέξεις', value: 3),
              StageCompletionSectionHeader(header: 'Επιβραβεύσεις Σταδίου'),
              StageDataListItem(title: 'Ολοκλήρωση σταδίου', value: 3),
              StageDataListItem(title: 'Λέξεις Σταδίου', value: 3),
              StageDataListItem(title: 'Έξτρα λέξεις', value: 3),
              TotalPointsEarned(),
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.spacingXL),
                child: CustomFilledButton(
                  text: context.translate.nextStageBtnText,
                  onPressed: () {
                    // context.read<StageBloc>().add(
                    //   NextStageButtonPressed(progress),
                    // );
                  },
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    AppPages.home.go();
                  },
                  child: CustomText(
                    'Πίσω στην αρχική',
                    textType: CustomTextType.regularBody,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
