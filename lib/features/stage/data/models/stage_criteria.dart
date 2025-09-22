import 'dart:math';

class StageCriteria {
  final int biggestWordLength;
  final int smallestWordLength;
  final int minBigWords;
  final int minStageWords;
  final int maxStageWords;
  final LevelProgressDifficulty difficulty;

  StageCriteria({
    required this.biggestWordLength,
    required this.smallestWordLength,
    required this.minBigWords,
    required this.minStageWords,
    required this.maxStageWords,
    required this.difficulty,
  });

  @override
  String toString() {
    return '''
StageCriteria:
  Difficulty: ${difficulty.name}
  Word Length: $smallestWordLength-$biggestWordLength letters
  Word Count: $minStageWords-$maxStageWords words
  Min Big Words: $minBigWords
  ''';
  }

  factory StageCriteria.fromLevelAndProgress({
    required int level,
    required double progress,
  }) {
    final difficulty = _selectDifficultyWeighted(progress);
    final biggestWord = level + 2;
    final smallestWord = _getSmallestWordLength(level);

    final minWords = difficulty.minWordsPerLevel(level);
    final maxWords = difficulty.maxWordsPerLevel(level);

    final minBigWords = difficulty.minBigWordsPerLevel(level);

    return StageCriteria(
      biggestWordLength: biggestWord,
      smallestWordLength: smallestWord,
      minBigWords: minBigWords,
      minStageWords: minWords,
      maxStageWords: maxWords,
      difficulty: difficulty,
    );
  }

  static int _getSmallestWordLength(int level) {
    if (level <= 6) return 3;
    if (level <= 8) return 4;
    return 5;
  }

  static LevelProgressDifficulty _selectDifficultyWeighted(double progress) {
    final random = Random();
    final rand = random.nextDouble();

    if (progress > 0.90) {
      return LevelProgressDifficulty.veryHard;
    } else if (progress > 0.70) {
      return rand < 0.7
          ? LevelProgressDifficulty.hard
          : LevelProgressDifficulty.veryHard;
    } else if (progress > 0.25) {
      return rand < 0.6
          ? LevelProgressDifficulty.medium
          : LevelProgressDifficulty.hard;
    } else {
      return rand < 0.7
          ? LevelProgressDifficulty.easy
          : LevelProgressDifficulty.medium;
    }
  }
}

enum LevelProgressDifficulty {
  easy,
  medium,
  hard,
  veryHard;

  int minWordsPerLevel(int level) {
    const wordCounts = [
      [2, 3, 4, 5, 7, 7, 8, 9, 9, 10],
      [2, 4, 5, 6, 7, 8, 9, 9, 10, 11],
      [2, 5, 6, 7, 8, 8, 9, 10, 11, 12],
      [3, 6, 7, 7, 8, 9, 10, 11, 11, 14],
    ];

    return wordCounts[index][level - 1];
  }

  int minBigWordsPerLevel(int level) {
    if (level < 5) return 1;

    if (index < 2) return 1;

    return 2;
  }

  int maxWordsPerLevel(int level) => switch (this) {
    easy || medium => level + 4,
    hard => level + 6,
    veryHard => level + 8,
  };
}
