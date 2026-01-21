import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement.dart';
import 'package:hive/hive.dart';

part 'word_placement_tracker.g.dart';

@HiveType(typeId: 5)
class WordPlacementTracker extends HiveObject {
  @HiveField(0)
  final List<WordPlacement> placements;
  @HiveField(1)
  final List<String> foundWords;
  @HiveField(2)
  final List<int> revealedPositions;
  @HiveField(3)
  final List<int> commonPositions;
  @HiveField(4)
  final List<String> extraWords;

  WordPlacementTracker({
    List<WordPlacement>? placements,
    List<String>? foundWords,
    List<int>? revealedPositions,
    List<int>? commonPositions,
    List<String>? extraWords,
  }) : placements = placements ?? [],
       foundWords = foundWords ?? [],
       revealedPositions = revealedPositions ?? [],
       commonPositions = commonPositions ?? [],
       extraWords = extraWords ?? [];

  factory WordPlacementTracker.copyWith({
    required List<WordPlacement> placements,
    required List<String> foundWords,
    required List<int> revealedPositions,
    required List<int> commonPositions,
    required List<String> extraWords,
  }) {
    return WordPlacementTracker(
      placements: List.from(placements),
      foundWords: List.from(foundWords),
      revealedPositions: List.from(revealedPositions),
      commonPositions: List.from(commonPositions),
      extraWords: List.from(extraWords),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placements': placements.map((p) => p.toMap()).toList(),
      'foundWords': foundWords,
      'revealedPositions': revealedPositions,
      'commonPositions': commonPositions,
      'extraWords': extraWords,
    };
  }

  factory WordPlacementTracker.fromMap(Map<String, dynamic> map) {
    return WordPlacementTracker(
      placements: (map['placements'] as List?)
          ?.map((p) => WordPlacement.fromMap(p as Map<String, dynamic>))
          .toList(),
      foundWords: List<String>.from(map['foundWords'] as List? ?? []),
      revealedPositions: List<int>.from(
        map['revealedPositions'] as List? ?? [],
      ),
      commonPositions: List<int>.from(map['commonPositions'] as List? ?? []),
      extraWords: List<String>.from(map['extraWords'] as List? ?? []),
    );
  }

  bool get isEmpty => placements.isEmpty;
  int get wordCount => placements.length;
  bool get allWordsFound => foundWords.length == placements.length;

  int get smallestWordLength {
    if (placements.isEmpty) return 0;
    return placements.map((p) => p.word.length).reduce((a, b) => a < b ? a : b);
  }

  int get biggestWordLength {
    if (placements.isEmpty) return 0;
    return placements.map((p) => p.word.length).reduce((a, b) => a > b ? a : b);
  }

  void addPlacement(String word, List<int> positions) {
    placements.add(
      WordPlacement(
        word: word,
        positions: positions,
        isHorizontal: BoardHelper.isHorizontal(positions),
      ),
    );
  }

  WordPlacement getPlacement(int index) => placements[index];
  WordPlacement getPlacementFromWord(String word) =>
      placements.firstWhere((p) => p.word == word);
  WordPlacement getPlacementFromUniquePosition(int position) =>
      placements.firstWhere(
        (p) =>
            p.positions.contains(position) &&
            !commonPositions.contains(position),
      );
  List<WordPlacement> getPlacementsFromPosition(int position) =>
      placements.where((p) => p.positions.contains(position)).toList();

  List<String> get words => placements.map((p) => p.word).toList();
  List<List<int>> get allPositions =>
      placements.map((p) => p.positions).toList();

  List<int> get remainingPositions {
    final allPositions = <int>{};
    for (var placement in placements) {
      allPositions.addAll(placement.positions);
    }
    return allPositions.difference(revealedPositions.toSet()).toList();
  }

  void clear() {
    placements.clear();
  }

  void removeLast() {
    if (placements.isNotEmpty) {
      placements.removeLast();
    }
  }

  bool containsWord(String word) {
    return placements.any((p) => p.word == word);
  }

  bool isWordFound(String word) {
    return foundWords.contains(word) || extraWords.contains(word);
  }

  void markWordAsFound(String word) {
    foundWords.add(word);
  }

  void markWordAsExtra(String word) {
    extraWords.add(word);
  }

  void addRevealedPositions(List<int> posistions) {
    revealedPositions.addAll(posistions);
  }

  List<int>? getPositionsForWord(String word) {
    try {
      final placement = placements.firstWhere((p) => p.word == word);
      return placement.positions;
    } catch (e) {
      return null;
    }
  }

  List<String> placePositions(List<String> board) {
    for (var placement in placements) {
      for (int i = 0; i < placement.word.length; i++) {
        board[placement.positions[i]] = placement.word[i];
      }
    }

    return board;
  }
}
