import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/sound_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Environment(Env.full)
class SoundCubit extends Cubit<bool> {
  final SoundSettingsService _settingsService = SoundSettingsService();

  SoundCubit() : super(true) {
    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final enabled = await _settingsService.isSoundEnabled();
    emit(enabled);
  }

  Future<void> toggleSound(bool value) async {
    await _settingsService.setSoundEnabled(value);
    emit(value);
  }
}
