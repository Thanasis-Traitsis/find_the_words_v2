import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/version/version_service.dart';
import 'package:find_the_words/core/di/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'version_state.dart';

@lazySingleton
@Environment(Env.minimal)
class VersionCubit extends Cubit<VersionState> {
  final VersionService _versionService;

  VersionCubit(this._versionService) : super(const VersionState());

  Future<void> checkVersion() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final result = await _versionService.checkVersion();

      emit(
        state.copyWith(
          currentVersion: result.currentVersion,
          minimumVersion: result.minimumVersion,
          needsForceUpdate: result.needsForceUpdate,
          needsOptionalUpdate: result.needsOptionalUpdate,
          updateMessage: result.message,
          whatsNew: result.whatsNew,
          storeUrl: result.storeUrl,
          isLoading: false,
          hasError: false,
        ),
      );
    } catch (e) {
      debugPrint('Error in VersionCubit: $e');
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  Future<void> refreshVersion() async {
    _versionService.clearCache();
    await checkVersion();
  }

  Future<void> dismissOptionalUpdate() async {
    await _versionService.dismissOptionalUpdate(
      state.minimumVersion,
      state.currentVersion,
    );

    emit(
      state.copyWith(optionalUpdateDismissed: true, needsOptionalUpdate: false),
    );
  }
}
