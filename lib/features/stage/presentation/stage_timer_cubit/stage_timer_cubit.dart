import 'dart:async';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StageTimerCubit extends Cubit<int> {
  Timer? _timer;
  final int stageId;
  final SharedPreferences prefs;
   late final String _timerKey; 
  
  StageTimerCubit(this.stageId, this.prefs) : super(0) {
    _timerKey = AppKeys.timerKey(stageId);
    _initialize();
  }
  
  Future<void> _initialize() async {
    final savedTime = prefs.getInt(_timerKey) ?? 0;
    emit(savedTime);
    _startTimer();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state + 1);
    });
  }
  
  void pause() => _timer?.cancel();
  
  Future<void> saveAndClear() async {
    _timer?.cancel();
    await prefs.remove(_timerKey);
  }
  
  Future<void> save() async {
    await prefs.setInt(_timerKey, state);
  }
  
  @override
  Future<void> close() {
    save();
    _timer?.cancel();
    return super.close();
  }
}
