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

  CurrentStage({
    required this.allWords,
    required this.letters,
    required this.board,
    required this.placementTracker,
  });
}
