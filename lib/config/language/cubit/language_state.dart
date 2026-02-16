part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final AppLanguage appLanguage;
  final bool isFirstTime;

  const LanguageState(this.appLanguage, {this.isFirstTime = false});

  LanguageState copyWith({AppLanguage? appLanguage, bool? isFirstTime}) {
    return LanguageState(
      appLanguage ?? this.appLanguage,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }

  @override
  List<Object?> get props => [appLanguage, isFirstTime];

  @override
  String toString() {
    return 'LanguageState(appLanguage: $appLanguage)';
  }
}
