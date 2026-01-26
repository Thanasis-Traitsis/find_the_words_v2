import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpOverlayCubit extends Cubit<HelpOverlayState> {
  HelpOverlayCubit() : super(HelpOverlayState.hidden());
  
  void show(List<GlobalKey> keys) {
    emit(HelpOverlayState.visible(keys));
  }
  
  void hide() {
    emit(HelpOverlayState.hidden());
  }
  
  void toggle(List<GlobalKey> keys) {
    state.isVisible ? hide() : show(keys);
  }
}