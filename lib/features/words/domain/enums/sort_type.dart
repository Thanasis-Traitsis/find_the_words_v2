import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:flutter/material.dart';

enum SortType {
  alphabeticalAZ,
  alphabeticalZA,
  smallWordsFirst,
  bigWordsFirst;

  String getLabel(BuildContext context) {
    switch (this) {
      case SortType.alphabeticalAZ:
        return context.translate.sortByAlphabeticalAZ;
      case SortType.alphabeticalZA:
        return context.translate.sortByAlphabeticalZA;
      case SortType.smallWordsFirst:
        return context.translate.sortBySmallestToBiggest;
      case SortType.bigWordsFirst:
        return context.translate.sortByBiggestToSmallest;
    }
  }
}
