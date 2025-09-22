import 'package:find_the_words/features/stage/domain/helpers/board_helper.dart';

class WordPlacementTracker {
  final List<WordPlacement> _placements = [];

  bool get isEmpty => _placements.isEmpty;
  int get wordCount => _placements.length;

  void addPlacement(String word, List<int> positions) {
    _placements.add(
      WordPlacement(
        word: word,
        positions: positions,
        isHorizontal: BoardHelper.isHorizontal(positions),
      ),
    );
  }

  WordPlacement getPlacement(int index) => _placements[index];

  List<String> get words => _placements.map((p) => p.word).toList();
  List<List<int>> get allPositions =>
      _placements.map((p) => p.positions).toList();

  void clear() {
    _placements.clear();
  }

  void removeLast() {
    if (_placements.isNotEmpty) {
      _placements.removeLast();
    }
  }

  bool containsWord(String word) {
    return _placements.any((p) => p.word == word);
  }
}

class WordPlacement {
  final String word;
  final List<int> positions;
  final bool isHorizontal;

  WordPlacement({
    required this.word,
    required this.positions,
    required this.isHorizontal,
  });
}
