import 'dart:ui' as ui;

class LanguageService {
  static String getDeviceLanguage() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;

    return deviceLocale.languageCode;
  }
}
