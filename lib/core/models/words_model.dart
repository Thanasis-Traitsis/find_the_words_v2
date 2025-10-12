import 'package:hive/hive.dart';

part 'words_model.g.dart';

@HiveType(typeId: 3)
class WordsModel extends HiveObject {
  @HiveField(0)
  final Map<String, dynamic> words;

  WordsModel({required this.words});
}
