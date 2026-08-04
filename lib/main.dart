import 'package:find_the_words/app/app_loader.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupMinimalServiceLocator();

  runApp(const MyAppLoader());
}
