import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
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
        suffixOnTap: () {},
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return Center(child: CircularProgressIndicator());
          }
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
                        StageAndLevelCard(
                          profileStatus: state.user.profileStatus,
                        ),
                        TotalWordsCard(
                          wordsListLength:
                              state.user.profileStatus.wordsModel.words.length,
                        ),
                      ],
                    ),
                    CustomFilledButton(
                      text: context.translate.nextStageBtnText,
                      onPressed: () {
                        context.read<StageBloc>().add(
                          NextStageButtonPressed(state.user.profileStatus),
                        );
                        AppPages.stage.push(
                          extra: state.user.profileStatus.stage,
                        );
                      },
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
