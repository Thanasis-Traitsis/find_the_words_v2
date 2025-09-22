import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:find_the_words/features/auth/data/models/profile_status_model.dart';
import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/services/stage_generator_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  final StageGeneratorService _stageGeneratorService;

  StageBloc({required StageGeneratorService stageGeneratorService})
    : _stageGeneratorService = stageGeneratorService,
      super(StageInitial()) {
    on<NextStageButtonPressed>(_onNextStageButtonPressed);
  }

  void _onNextStageButtonPressed(
    NextStageButtonPressed event,
    Emitter<StageState> emit,
  ) async {
    final int userLevel = event.profileStatus.level + 3;
    final int letterFileNum = userLevel + 2;

    final stageData = await _stageGeneratorService.generateStage(
      filePath: FileUtils.stageFile(letterFileNum),
      level: userLevel,
      progress: event.profileStatus.progress,
    );

    // Save the current stage locally

    // Upload the current stage online

    emit(StageCreated(stageData));
  }
}
