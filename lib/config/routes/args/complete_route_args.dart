import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/features/stage/data/models/stage_results.dart';

class CompleteRouteArgs {
  final StageResults stageResults;

  const CompleteRouteArgs({required this.stageResults});

  void pushReplacement() => AppPages.complete.pushReplacement(extra: this);
}
