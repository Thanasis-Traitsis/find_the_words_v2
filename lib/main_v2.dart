import 'package:find_the_words/firebase_options.dart';
import 'package:find_the_words/v2/app_v2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// v2 entry point - a fresh start, built up one step at a time, with no
/// get_it/injectable. Run it directly with:
///   flutter run -t lib/main_v2.dart
///
/// The existing app (lib/main.dart) is untouched and keeps working as
/// before - this is a separate, parallel entry point.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  runApp(AppV2(prefs: prefs));
}
