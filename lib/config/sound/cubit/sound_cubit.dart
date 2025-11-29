import 'package:find_the_words/core/services/sound_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
