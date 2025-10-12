import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/screens/dismiss_keyboard_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/features/words/presentation/widgets/filter_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/search_textfield.dart';
import 'package:find_the_words/features/words/presentation/widgets/sort_by_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/word_row_item.dart';
import 'package:flutter/material.dart';

class TotalWordsScreen extends StatelessWidget {
  final Map<String, dynamic> words;

  const TotalWordsScreen({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScreen(
      child: CustomScreen(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: BigHeading(pageTitle: context.translate.wordsScreenName),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingM,
                ),
                sliver: SliverToBoxAdapter(child: SearchTextfield()),
              ),
              SliverAppBar(
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                backgroundColor: context.colors.background,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 0,
                title: Row(
                  spacing: AppSpacing.spacingM,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const FilterButton(), const SortByButton()],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingL,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: words.length,
                    (context, index) {
                      final word = words.keys.elementAt(index);
                      final meanings = words.values.elementAt(index);
                      return Container(
                        margin: index == 0
                            ? null
                            : const EdgeInsets.only(top: AppSpacing.spacingL),
                        child: WordRowItem(word: word, meanings: meanings),
                      );
                    },
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
