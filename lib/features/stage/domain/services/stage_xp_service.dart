import 'package:find_the_words/core/constants/xp_constants.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';
import 'package:find_the_words/features/stage/domain/helpers/stage_difficulty_calculator.dart';
import 'package:find_the_words/features/stage/domain/helpers/xp_calculator.dart';

class StageXPService {
  static StageResults calculateStageResults({
    required CurrentStage stage,
    required int level,
    required int stageNumber,
    required int timeInSeconds,
    required double currentProgress,
    required int xpMultiplier, 
  }) {
    final difficultyCalc = StageDifficultyCalculator(
      level: level,
      letters: stage.letters,
      crosswordWordsCount: stage.placementTracker.wordCount,
      totalPossibleWords: stage.allWords.length,
      smallestWordLength: stage.placementTracker.smallestWordLength,
      biggestWordLength: stage.placementTracker.biggestWordLength,
    );
    
    final difficulty = difficultyCalc.getDifficulty();
    
    final tempResults = StageResults(
      level: level,
      stage: stageNumber,
      crosswordWords: stage.placementTracker.wordCount,
      foundExtraWords: stage.placementTracker.extraWords.length,
      timeInSeconds: timeInSeconds,
      difficulty: difficulty,
      xpEarned: 0,
      currentProgress: currentProgress,
      newProgress: 0,
    );
    
    final xpCalc = XPCalculator(
      stageResults: tempResults,
      difficultyCalculator: difficultyCalc,
      multiplier: xpMultiplier
    );
    
    final xpEarned = xpCalc.calculateTotalXP();

    int totalXP = XPConstants.getXPForLevel(level);
    double progressPercentage = (xpEarned * 100) / totalXP;
    double newProgress = currentProgress + progressPercentage;
    
    return StageResults(
      level: level,
      stage: stageNumber,
      crosswordWords: stage.placementTracker.wordCount,
      foundExtraWords: stage.placementTracker.extraWords.length,
      timeInSeconds: timeInSeconds,
      difficulty: difficulty,
      xpEarned: xpEarned,
      currentProgress: currentProgress,
      newProgress: newProgress,
      xpBoost: xpMultiplier != 1 ? xpMultiplier : null
    );
  }
}