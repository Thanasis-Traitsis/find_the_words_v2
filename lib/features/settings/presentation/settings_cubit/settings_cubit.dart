import 'package:find_the_words/core/services/previous_stage_words_service.dart';
import 'package:find_the_words/features/settings/domain/usecases/open_email_usecase.dart';
import 'package:find_the_words/features/stage/domain/repositories/stage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final OpenEmailUseCase _openEmailUseCase;
  final PreviousStageWordsService _previousStageWordsService;
  final StageRepository _stageRepo;
  bool _emailWasOpened = false;

  SettingsCubit({
    required OpenEmailUseCase openEmailUseCase,
    required PreviousStageWordsService previousStageWordsService,
    required StageRepository stageRepo,
  }) : _openEmailUseCase = openEmailUseCase,
       _previousStageWordsService = previousStageWordsService,
       _stageRepo = stageRepo,
       super(SettingsInitial());

  Future<void> resetStage(int currentStageNumber) async {
    emit(SettingsLoading());

    await _stageRepo.resetStage(currentStageNumber);
    emit(SettingsStageReset());
  }

  Future<void> openReportBadWord() async {
    emit(SettingsLoading());

    final allPreviousWords = await _previousStageWordsService
        .getPrevStageWords();
    emit(SettingsReportBadWord(allPreviousWords));
  }

  Future<void> openEmail({required String subject, String? body}) async {
    emit(SettingsLoading());

    final success = await _openEmailUseCase(subject: subject, body: body);

    if (success) {
      _emailWasOpened = true;
      emit(SettingsInitial());
    } else {
      emit(SettingsEmailFailed("thanasiswd@gmail.com"));
    }
  }

  void onAppResumed() {
    if (_emailWasOpened) {
      emit(SettingsEmailReturned());
      _emailWasOpened = false;
    }
  }

  void resetSettingsState() {
    emit(SettingsInitial());
  }

  @override
  Future<void> close() {
    print("object yea yea yea");
    _emailWasOpened = false;
    return super.close();
  }
}
