import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/utils/file_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  static const String _usedWordsKey = AppKeys.usedWordsKey;

  StageBloc() : super(StageInitial()) {
    on<NextStageButtonPressed>(_onNextStageButtonPressed);
  }

  void _onNextStageButtonPressed(
    NextStageButtonPressed event,
    Emitter<StageState> emit,
  ) async {
    final stageFile = await FileUtils.loadCompressedJson(event.filePath);
    
    int randomStageChoice = Random().nextInt(stageFile.length);
    var wordEntry = stageFile.entries.elementAt(randomStageChoice);

    final prefs = await SharedPreferences.getInstance();
    final List<String> usedWordsList = prefs.getStringList(_usedWordsKey) ?? [];

    if(!usedWordsList.contains(wordEntry.key)) {
      print("object");
    }
  }
}
