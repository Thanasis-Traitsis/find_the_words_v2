import 'package:find_the_words/features/stage/data/models/stage_difficulty.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:find_the_words/features/stage/domain/helpers/stage_difficulty_calculator.dart';

class XPCalculator {
  final StageResults stageResults;
  final StageDifficultyCalculator difficultyCalculator;

  XPCalculator({
    required this.stageResults,
    required this.difficultyCalculator,
  });

  int calculateTotalXP() {
    // Base XP from stage completion
    final baseXP = _getBaseXP();

    // Difficulty multiplier (0.7 - 1.5x)
    final difficultyMultiplier = _getDifficultyMultiplier();

    // Time bonus/penalty (-20% to +50%)
    final timeMultiplier = _getTimeMultiplier();

    // Extra words bonus
    final extraWordsBonus = _getExtraWordsBonus();

    // Calculate final XP
    final totalXP =
        (baseXP * difficultyMultiplier * timeMultiplier) + extraWordsBonus;

    return totalXP.round().clamp(10, 1000);
  }

  double _getBaseXP() {
    final levelXP = (100 / difficultyCalculator.level);

    final crosswordBonus = stageResults.getPointsForCrosswordWords() * 10.0;

    return levelXP + crosswordBonus;
  }

  double _getDifficultyMultiplier() {
    final difficulty = difficultyCalculator.getDifficulty();

    switch (difficulty) {
      case StageDifficulty.easy:
        return 0.8;
      case StageDifficulty.normal:
        return 1.0;
      case StageDifficulty.hard:
        return 1.2;
      case StageDifficulty.veryHard:
        return 1.4;
    }
  }

  double _getTimeMultiplier() {
    final expectedTime = _calculateExpectedTime();
    final actualTime = stageResults.timeInSeconds;

    if (actualTime <= 0) return 1.0;

    final ratio = actualTime / expectedTime;

    // Fast completion = bonus, slow completion = penalty
    if (ratio < 0.5) return 1.5; // Super fast: +50%
    if (ratio < 0.7) return 1.3; // Fast: +30%
    if (ratio < 0.9) return 1.15; // Decent: +15%
    if (ratio < 1.2) return 1.0; // Normal: no change
    if (ratio < 1.5) return 0.95; // Slow: -5%
    if (ratio < 2.0) return 0.9; // Very slow: -10%
    return 0.8; // Extremely slow: -20%
  }

  int _calculateExpectedTime() {
    final baseTime = 30 + (stageResults.level * 30);

    final wordTime = stageResults.crosswordWords * 15;

    return baseTime + wordTime;
  }

  double _getExtraWordsBonus() {
    return stageResults.getPointsForExtraWords() * 8.0;
  }

  Map<String, dynamic> getXPBreakdown() {
    final baseXP = _getBaseXP();
    final diffMultiplier = _getDifficultyMultiplier();
    final timeMultiplier = _getTimeMultiplier();
    final extraBonus = _getExtraWordsBonus();
    final totalXP = calculateTotalXP();

    return {
      'baseXP': baseXP.round(),
      'difficultyMultiplier': diffMultiplier,
      'timeMultiplier': timeMultiplier,
      'extraWordsBonus': extraBonus.round(),
      'totalXP': totalXP,
      'difficulty': difficultyCalculator.getDifficulty(),
      'difficultyScore': difficultyCalculator
          .calculateDifficultyScore()
          .round(),
    };
  }
}
