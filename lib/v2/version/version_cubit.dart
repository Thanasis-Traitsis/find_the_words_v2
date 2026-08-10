import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/version/version_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object?> get props => [];
}

/// Not checked yet, or checked and no update is required (including when
/// the check was skipped entirely because there's no internet, or the
/// check itself failed - either way we don't block the user on it).
class VersionOk extends VersionState {}

class VersionForceUpdate extends VersionState {
  final String message;
  final String storeUrl;

  const VersionForceUpdate({required this.message, required this.storeUrl});

  @override
  List<Object?> get props => [message, storeUrl];
}

/// Checks the app version against the minimum required version - but only
/// if there's internet access. Offline, or a failed check, is treated as
/// "can't verify right now" rather than an error - the user is never
/// blocked by a version check that couldn't run.
class VersionCubit extends Cubit<VersionState> {
  final ConnectivityService _connectivityService;
  final VersionService _versionService;

  VersionCubit({
    required ConnectivityService connectivityService,
    required VersionService versionService,
  }) : _connectivityService = connectivityService,
       _versionService = versionService,
       super(VersionOk());

  Future<void> checkIfOnline() async {
    final hasInternet = await _connectivityService.hasInternet();
    if (!hasInternet) return;

    try {
      final result = await _versionService.checkVersion();
      if (result.needsForceUpdate) {
        emit(
          VersionForceUpdate(
            message: result.message,
            storeUrl: result.storeUrl,
          ),
        );
      }
    } catch (e) {
      debugPrint('Version check failed, proceeding anyway: $e');
    }
  }
}
