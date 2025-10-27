import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

enum StageDifficulty {
  easy,
  normal,
  hard,
  veryHard;

  String getValue(BuildContext context) {
    switch (this) {
      case StageDifficulty.easy:
        return context.translate.easy;
      case StageDifficulty.normal:
        return context.translate.normal;
      case StageDifficulty.hard:
        return context.translate.hard;
      case StageDifficulty.veryHard:
        return context.translate.veryHard;
    }
  }

  Color getTextColor(BuildContext context) {
    switch (this) {
      case StageDifficulty.easy:
        return context.colors.darkBlue;
      case StageDifficulty.normal:
        return context.colors.darkGreen;
      case StageDifficulty.hard:
      case StageDifficulty.veryHard:
        return context.colors.white;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    switch (this) {
      case StageDifficulty.easy:
        return context.colors.lightBlue;
      case StageDifficulty.normal:
        return context.colors.lightGreen;
      case StageDifficulty.hard:
        return context.colors.primary;
      case StageDifficulty.veryHard:
        return context.colors.error;
    }
  }
}