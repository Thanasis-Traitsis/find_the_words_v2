import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:hive/hive.dart';

part 'progress_collection.g.dart';

@HiveType(typeId: 3)
class ProgressCollection extends HiveObject {
  @HiveField(0)
  final Map<String, ProfileStatusModel> progressMap;

  ProgressCollection({required this.progressMap});
}
