import 'package:find_the_words/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension TextExtensions on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}