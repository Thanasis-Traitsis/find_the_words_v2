import 'package:find_the_words/config/routes/app_pages.dart';

class StageRouteArgs {
  final int stage;
  final int level;

  const StageRouteArgs({required this.stage, required this.level});

  void push() => AppPages.stage.push(extra: this);
  void pushReplacement() => AppPages.stage.pushReplacement(extra: this);
}
