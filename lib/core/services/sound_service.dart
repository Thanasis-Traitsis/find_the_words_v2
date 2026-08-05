import 'package:audioplayers/audioplayers.dart';
import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:find_the_words/core/di/service_locator.dart';
import 'package:find_the_words/features/stage/presentation/stage_bloc/stage_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  final SoundSettingsService _settingsService = SoundSettingsService();

  Future<void> playResultSound(StageActive state) async {
    final soundEnabled = await _settingsService.isSoundEnabled();
    if (!soundEnabled) return;

    final soundFile = switch (state) {
      StageInProgress() => 'correct_word',
      ExtraWordFound() => 'extra_word',
      WordInvalid() || WordAlreadyFound() => 'wrong_word',
      StageCompleted() => 'stage_complete',
      _ => null,
    };

    if (soundFile != null) {
      await _player.play(AssetSource('sound/$soundFile.mp3'));
    }
  }

  void dispose() {
    _player.dispose();
  }
}

class SoundSettingsService {
  static const String _soundEnabledKey = AppKeys.soundKey;
  final _prefs = getIt<SharedPreferences>();

  Future<bool> isSoundEnabled() async {
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }
}
