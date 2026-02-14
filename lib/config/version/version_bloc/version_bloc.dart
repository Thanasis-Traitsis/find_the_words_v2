import 'package:equatable/equatable.dart';
import 'package:find_the_words/config/version/version_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'version_event.dart';
part 'version_state.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  final VersionService _versionService;

  VersionBloc(this._versionService) : super(const VersionState()) {
    on<CheckVersion>(_onCheckVersion);
    on<RefreshVersion>(_onRefreshVersion);
    on<DismissOptionalUpdate>(_onDismissOptionalUpdate);
  }

  Future<void> _onCheckVersion(
    CheckVersion event,
    Emitter<VersionState> emit,
  ) async {
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
      debugPrint('Error in VersionBloc: $e');
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  Future<void> _onRefreshVersion(
    RefreshVersion event,
    Emitter<VersionState> emit,
  ) async {
    _versionService.clearCache();
    add(const CheckVersion());
  }

  Future<void> _onDismissOptionalUpdate(
    DismissOptionalUpdate event,
    Emitter<VersionState> emit,
  ) async {
    // ✅ Persist dismissal
    await _versionService.dismissOptionalUpdate(
      state.minimumVersion,
      state.currentVersion,
    );

    emit(
      state.copyWith(optionalUpdateDismissed: true, needsOptionalUpdate: false),
    );
  }
}
