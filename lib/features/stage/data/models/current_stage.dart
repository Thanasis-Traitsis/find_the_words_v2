import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:hive/hive.dart';

part 'current_stage.g.dart';

@HiveType(typeId: 4)
class CurrentStage extends HiveObject {
  @HiveField(0)
  final List<String> allWords;

  @HiveField(1)
  final List<String> letters;

  @HiveField(2)
  final List<String> board;

  @HiveField(3)
  final WordPlacementTracker placementTracker;

  @HiveField(4)
  final bool activeFreeze;

  CurrentStage({
    required this.allWords,
    required this.letters,
    required this.board,
    required this.placementTracker,
    this.activeFreeze = false
  });

  CurrentStage copyWith({
    List<String>? allWords,
    List<String>? letters,
    List<String>? board,
    WordPlacementTracker? placementTracker,
    bool? activeFreeze,
  }) {
    return CurrentStage(
      allWords: allWords ?? this.allWords,
      letters: letters ?? this.letters,
      board: board ?? this.board,
      placementTracker: placementTracker ?? this.placementTracker,
      activeFreeze: activeFreeze ?? this.activeFreeze,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allWords': allWords,
      'letters': letters,
      'board': board,
      'placementTracker': placementTracker.toMap(),
      'activeFreeze': activeFreeze,
    };
  }

  factory CurrentStage.fromMap(Map<String, dynamic> map) {
    return CurrentStage(
      allWords: List<String>.from(map['allWords'] as List? ?? []),
      letters: List<String>.from(map['letters'] as List? ?? []),
      board: List<String>.from(map['board'] as List? ?? []),
      placementTracker: WordPlacementTracker.fromMap(
        map['placementTracker'] as Map<String, dynamic>? ?? {},
      ),
      activeFreeze: map['activeFreeze'] as bool? ?? false,
    );
  }
}
