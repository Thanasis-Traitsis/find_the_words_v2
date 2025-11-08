import 'dart:math';

import 'package:find_the_words/config/language/app_language.dart';
import 'package:find_the_words/config/language/cubit/language_cubit.dart';
import 'package:find_the_words/core/services/service_locator.dart';

class WordFilters {
  final Set<String> selectedLetters;
  final Set<int> selectedWordLengths;

  const WordFilters({
    required this.selectedLetters,
    required this.selectedWordLengths,
  });

  factory WordFilters.initial() {
    return const WordFilters(selectedLetters: {}, selectedWordLengths: {});
  }

  WordFilters copyWith({
    Set<String>? selectedLetters,
    Set<int>? selectedWordLengths,
  }) {
    return WordFilters(
      selectedLetters: selectedLetters ?? this.selectedLetters,
      selectedWordLengths: selectedWordLengths ?? this.selectedWordLengths,
    );
  }

  bool get isFilteringByLetters => selectedLetters.isNotEmpty;

  bool get isFilteringByLength => selectedWordLengths.isNotEmpty;

  int get minWordLength =>
      selectedWordLengths.isEmpty || selectedWordLengths.length == 1
      ? LetterFilterConstants.commonWordLengths.reduce(min)
      : selectedWordLengths.reduce(min);

  int get maxWordLength =>
      selectedWordLengths.isEmpty || selectedWordLengths.length == 1
      ? LetterFilterConstants.commonWordLengths.reduce(max)
      : selectedWordLengths.reduce(max);

  bool get hasActiveFilters => isFilteringByLetters || isFilteringByLength;

  int get filtersCount {
    if (hasActiveFilters) {
      int count = 0;
      if (isFilteringByLetters) {
        count = count + selectedLetters.length;
      } else {
        count++;
      }
      if (isFilteringByLength) count++;
      return count;
    }
    return 1;
  }

  List<String> get lettersFromSelectedLang {
    final selectedLang = getIt<LanguageCubit>().state.appLanguage;

    return selectedLang == AppLanguage.greek
        ? LetterFilterConstants.alphabetEL
        : LetterFilterConstants.alphabetEN;
  }
}

class LetterFilterConstants {
  static const List<String> alphabetEL = [
    'Α',
    'Β',
    'Γ',
    'Δ',
    'Ε',
    'Ζ',
    'Η',
    'Θ',
    'Ι',
    'Κ',
    'Λ',
    'Μ',
    'Ν',
    'Ξ',
    'Ο',
    'Π',
    'Ρ',
    'Σ',
    'Τ',
    'Υ',
    'Φ',
    'Χ',
    'Ψ',
    'Ω',
  ];

  static const List<String> alphabetEN = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static const List<int> commonWordLengths = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
}
