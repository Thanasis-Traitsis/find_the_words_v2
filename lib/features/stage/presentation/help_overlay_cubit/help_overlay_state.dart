
import 'package:flutter/material.dart';

class HelpOverlayState {
  final bool isVisible;
  final List<GlobalKey> keysToHighlight;
  
  HelpOverlayState.visible(this.keysToHighlight) : isVisible = true;
  HelpOverlayState.hidden() : isVisible = false, keysToHighlight = const [];
}
