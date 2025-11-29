import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_chip.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersChipsContainer extends StatelessWidget {
  const FiltersChipsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalWordsBloc, TotalWordsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: AppSpacing.spacingS,
            children: [
              if (state.filters.selectedLetters.isEmpty &&
                  state.searchQuery.isEmpty)
                CustomChip(chipLabel: context.translate.chipAllLetters),

              if (state.searchQuery.isNotEmpty)
                CustomChip(chipLabel: '"${state.searchQuery}"'),

              if (state.filters.selectedLetters.isNotEmpty)
                CustomChip(
                  chipLabel: context.translate.chipSelectedLetters(
                    state.filters.selectedLetters.join(', '),
                  ),
                ),

              if (state.filters.selectedWordLengths.isNotEmpty)
                CustomChip(
                  chipLabel: context.translate.chipSelectedRangeOfWordLength(
                    state.filters.minWordLength,
                    state.filters.maxWordLength,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
