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

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'positions': positions,
      'isHorizontal': isHorizontal,
      'isUsed': isUsed,
    };
  }

  factory WordPlacement.fromMap(Map<String, dynamic> map) {
    return WordPlacement(
      word: map['word'] as String,
      positions: List<int>.from(map['positions'] as List),
      isHorizontal: map['isHorizontal'] as bool? ?? false,
      isUsed: map['isUsed'] as bool? ?? false,
    );
  }
}
