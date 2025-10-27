import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_appbar.dart';
import 'package:find_the_words/core/widgets/custom_filled_button.dart';
import 'package:find_the_words/core/widgets/language_button.dart';
import 'package:find_the_words/features/auth/auth_cubit/auth_cubit.dart';
import 'package:find_the_words/features/home/presentation/widgets/logo_container.dart';
import 'package:find_the_words/features/home/presentation/widgets/stage_and_level_card.dart';
import 'package:find_the_words/features/home/presentation/widgets/total_words_card.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      appBar: CustomAppbar.withUserPoints(
        isHomePage: true,
        suffixWidget: LanguageButton(),
        suffixIcon: 'settings',
        suffixOnTap: () {
          AppPages.settings.push();
        },
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return Center(child: CircularProgressIndicator());
          }

          final user = state.user;
          final progress = user.currentProgress;

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const LogoContainer(),
                        StageAndLevelCard(profileStatus: progress),
                        TotalWordsCard(words: progress.wordsModel.words),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spacingXL,
                      ),
                      child: CustomFilledButton(
                        text: context.translate.nextStageBtnText,
                        onPressed: () {
                          getIt<StageBloc>().add(
                            NextStageButtonPressed(progress),
                          );

                          AppPages.stage.push(
                            extra: {
                              'stage': user.currentProgress.stage,
                              'level': user.currentProgress.level,
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
