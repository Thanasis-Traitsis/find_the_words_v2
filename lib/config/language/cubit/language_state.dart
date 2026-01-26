part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final AppLanguage appLanguage;
  final bool isFirstTime;
  final bool isLoading;

  const LanguageState(this.appLanguage, {this.isFirstTime = false, this.isLoading = false});

  LanguageState copyWith({AppLanguage? appLanguage, bool? isFirstTime, bool? isLoading}) {
    return LanguageState(
      appLanguage ?? this.appLanguage,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [appLanguage, isLoading];

  @override
  String toString() {
    return 'LanguageState(appLanguage: $appLanguage)';
  }
}
