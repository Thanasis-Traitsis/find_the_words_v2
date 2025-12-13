import 'package:find_the_words/features/stage/data/models/stage_difficulty.dart';

class StageResults {
  final int level;
  final int stage;
  final int crosswordWords;
  final int foundExtraWords;
  final int timeInSeconds;
  final StageDifficulty difficulty;
  final int xpEarned;
  final double currentProgress;
  final double newProgress;
  final int? xpBoost; 

  StageResults({
    required this.level,
    required this.stage,
    required this.crosswordWords,
    required this.foundExtraWords,
    required this.timeInSeconds,
    required this.difficulty,
    required this.xpEarned,
    required this.currentProgress,
    required double newProgress,
    this.xpBoost,
  }) : newProgress = newProgress.clamp(0, 100);

  String getFormattedTime() {
    final hours = timeInSeconds ~/ 3600;
    final minutes = (timeInSeconds % 3600) ~/ 60;
    final seconds = timeInSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int getPointsForStage() {
    switch (level) {
      case 1:
        return 3;
      case 2:
        return 5;
      case 3:
        return 8;
      case 4:
        return 10;
      case 5:
        return 12;
      case 6:
        return 15;
      case 7:
        return 20;
      case 8:
        return 25;
      case 9:
        return 30;
      default:
        return 40;
    }
  }

  int getPointsForCrosswordWords() {
    if (crosswordWords < 3) {
      return 1;
    } else if (crosswordWords < 5) {
      return 2;
    } else if (crosswordWords < 8) {
      return 3;
    } else if (crosswordWords < 10) {
      return 4;
    } else if (crosswordWords < 14) {
      return 5;
    } else {
      return 7;
    }
  }

  int getPointsForExtraWords() {
    if (foundExtraWords < 1) {
      return 0;
    } else if (foundExtraWords < 3) {
      return 2;
    } else if (foundExtraWords < 6) {
      return 4;
    } else if (foundExtraWords < 8) {
      return 6;
    } else if (foundExtraWords < 10) {
      return 8;
    } else {
      return 10;
    }
  }

  int getPointsForLevelup() {
    switch (level) {
      case 1:
        return 15;
      case 2:
        return 25;
      case 3:
        return 40;
      case 4:
        return 60;
      case 5:
        return 80;
      case 6:
        return 100;
      case 7:
        return 120;
      case 8:
        return 150;
      case 9:
        return 200;
      default:
        return 250;
    }
  }

  int totalPointsForStage() =>
      getPointsForStage() +
      getPointsForCrosswordWords() +
      getPointsForExtraWords() +
      (newProgress == 100 ? getPointsForLevelup() : 0);
}
