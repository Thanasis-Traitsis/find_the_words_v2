import 'package:hive/hive.dart';

part 'word_placement.g.dart';

@HiveType(typeId: 6)
class WordPlacement extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final List<int> positions;
  @HiveField(2)
  final bool isHorizontal;
  @HiveField(3)
  final bool isUsed;

  WordPlacement({
    required this.word,
    required this.positions,
    required this.isHorizontal,
    this.isUsed = false,
  });
}
