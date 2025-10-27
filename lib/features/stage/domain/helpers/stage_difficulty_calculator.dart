import 'package:find_the_words/core/constants/xp_constants.dart';
import 'package:find_the_words/features/stage/data/models/stage_difficulty.dart';

class StageDifficultyCalculator {
  final int level;
  final List<String> letters;
  final int crosswordWordsCount;
  final int totalPossibleWords;
  final int smallestWordLength;
  final int biggestWordLength;
  
  StageDifficultyCalculator({
    required this.level,
    required this.letters,
    required this.crosswordWordsCount,
    required this.totalPossibleWords,
    required this.smallestWordLength,
    required this.biggestWordLength,
  });
  
  double calculateDifficultyScore() {
    double score = 0.0;
    
    // 1. Consonant ratio (max 25 points)
    score += _calculateConsonantScore() * 25;
    
    // 2. Letter rarity (max 20 points)
    score += _calculateLetterRarityScore() * 20;
    
    // 3. Smallest word length (max 20 points)
    score += _calculateSmallestWordScore() * 20;
    
    // 4. Word availability ratio (max 25 points)
    score += _calculateWordAvailabilityScore() * 25;
    
    // 5. Crossword density (max 10 points)
    score += _calculateCrosswordDensityScore() * 10;
    
    return score.clamp(0, 100);
  }
  
  StageDifficulty getDifficulty() {
    final score = calculateDifficultyScore() - (25 + (level * 5) / level);
    if (score < 30) return StageDifficulty.easy;
    if (score < 55) return StageDifficulty.normal;
    if (score < 75) return StageDifficulty.hard;
    return StageDifficulty.veryHard;
  }
  
  double _calculateConsonantScore() {
    final consonantCount = letters
        .where((l) => XPConstants.simfona.contains(l.toUpperCase()))
        .length;
    final ratio = consonantCount / letters.length;
    
    if (ratio < 0.4) return 0.3;
    if (ratio < 0.5) return 0.5;
    if (ratio < 0.65) return 0.7; 
    if (ratio < 0.75) return 0.9;
    return 1.0; 
  }
  
  double _calculateLetterRarityScore() {
    double totalRarity = 0.0;
    for (final letter in letters) {
      totalRarity += XPConstants.letterRarity[letter.toUpperCase()] ?? 1.0;
    }
    final avgRarity = totalRarity / letters.length;
    
    return ((avgRarity - 1.0) / 1.8).clamp(0, 1);
  }
  
  double _calculateSmallestWordScore() {
    if (smallestWordLength <= 3) return 0.2;
    if (smallestWordLength == 4) return 0.5;
    if (smallestWordLength == 5) return 0.8;
    return 1.0;
  }
  
  double _calculateWordAvailabilityScore() {
    if (totalPossibleWords == 0) return 0.0;
    
    final usageRatio = crosswordWordsCount / totalPossibleWords;
    
    if (usageRatio < 0.2) return 0.2; 
    if (usageRatio < 0.4) return 0.4;
    if (usageRatio < 0.6) return 0.7;
    if (usageRatio < 0.8) return 0.9;
    return 1.0; 
  }
  
  double _calculateCrosswordDensityScore() {
    if (crosswordWordsCount < 4) return 0.3;
    if (crosswordWordsCount < 7) return 0.5;
    if (crosswordWordsCount < 10) return 0.7;
    return 1.0;
  }
}