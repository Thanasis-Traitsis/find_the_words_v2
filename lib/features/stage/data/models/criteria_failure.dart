import 'package:find_the_words/features/stage/data/models/stage_criteria.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';

enum CriteriaFailure { notEnoughTotalWords, tooManyWords, allMet }

class CriteriaValidationResult {
  final bool isValid;
  final Set<CriteriaFailure> failures;

  CriteriaValidationResult({required this.isValid, required this.failures});

  bool get needsMoreWords =>
      failures.contains(CriteriaFailure.notEnoughTotalWords);
  bool get hasTooManyWords => failures.contains(CriteriaFailure.tooManyWords);
}

CriteriaValidationResult validateStageCriteria({
  required WordPlacementTracker tracker,
  required StageCriteria criteria,
}) {
  final failures = <CriteriaFailure>{};

  if (tracker.wordCount < criteria.minStageWords) {
    failures.add(CriteriaFailure.notEnoughTotalWords);
  }

  if (tracker.wordCount > criteria.maxStageWords) {
    failures.add(CriteriaFailure.tooManyWords);
  }

  return CriteriaValidationResult(
    isValid: failures.isEmpty,
    failures: failures,
  );
}
