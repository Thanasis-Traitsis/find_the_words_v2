part of 'version_bloc.dart';

class VersionState extends Equatable {
  final String currentVersion;
  final String minimumVersion;
  final bool needsForceUpdate;
  final bool needsOptionalUpdate;
  final String updateMessage;
  final List<String> whatsNew;
  final String storeUrl;
  final bool isLoading;
  final bool hasError;
  final bool optionalUpdateDismissed;

  const VersionState({
    this.currentVersion = '',
    this.minimumVersion = '',
    this.needsForceUpdate = false,
    this.needsOptionalUpdate = false,
    this.updateMessage = '',
    this.whatsNew = const [],
    this.storeUrl = '',
    this.isLoading = false,
    this.hasError = false,
    this.optionalUpdateDismissed = false,
  });

  VersionState copyWith({
    String? currentVersion,
    String? minimumVersion,
    bool? needsForceUpdate,
    bool? needsOptionalUpdate,
    String? updateMessage,
    List<String>? whatsNew,
    String? storeUrl,
    bool? isLoading,
    bool? hasError,
    bool? optionalUpdateDismissed,
  }) {
    return VersionState(
      currentVersion: currentVersion ?? this.currentVersion,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      needsForceUpdate: needsForceUpdate ?? this.needsForceUpdate,
      needsOptionalUpdate: needsOptionalUpdate ?? this.needsOptionalUpdate,
      updateMessage: updateMessage ?? this.updateMessage,
      whatsNew: whatsNew ?? this.whatsNew,
      storeUrl: storeUrl ?? this.storeUrl,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      optionalUpdateDismissed:
          optionalUpdateDismissed ?? this.optionalUpdateDismissed,
    );
  }

  @override
  List<Object?> get props => [
    currentVersion,
    minimumVersion,
    needsForceUpdate,
    needsOptionalUpdate,
    updateMessage,
    whatsNew,
    storeUrl,
    isLoading,
    hasError,
    optionalUpdateDismissed,
  ];
}
