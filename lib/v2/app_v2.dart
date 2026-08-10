import 'package:find_the_words/config/version/version_service.dart';
import 'package:find_the_words/core/services/connectivity_service.dart';
import 'package:find_the_words/v2/language/language_cubit.dart';
import 'package:find_the_words/v2/theme/theme_cubit.dart';
import 'package:find_the_words/v2/version/version_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppV2 extends StatefulWidget {
  final SharedPreferences prefs;

  const AppV2({super.key, required this.prefs});

  @override
  State<AppV2> createState() => _AppV2State();
}

class _AppV2State extends State<AppV2> {
  late final LanguageCubit _languageCubit;
  late final ThemeCubit _themeCubit;
  late final VersionCubit _versionCubit;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _languageCubit = LanguageCubit(widget.prefs);
    _themeCubit = ThemeCubit(widget.prefs);
    _versionCubit = VersionCubit(
      connectivityService: ConnectivityService(),
      versionService: VersionService(widget.prefs),
    );

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // The three loads are independent of each other - run them together.
    await Future.wait([
      _languageCubit.load(),
      _themeCubit.load(),
      _versionCubit.checkIfOnline(),
    ]);

    if (mounted) setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _languageCubit.close();
    _themeCubit.close();
    _versionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _languageCubit),
        BlocProvider.value(value: _themeCubit),
        BlocProvider.value(value: _versionCubit),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeCubit>().state.themeMode;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: !_isReady
                ? const _LoadingScreen()
                : _ReadyScreen(
                    languageState: _languageCubit.state,
                    themeState: _themeCubit.state,
                    versionState: _versionCubit.state,
                  ),
          );
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ReadyScreen extends StatelessWidget {
  final LanguageState languageState;
  final ThemeState themeState;
  final VersionState versionState;

  const _ReadyScreen({
    required this.languageState,
    required this.themeState,
    required this.versionState,
  });

  @override
  Widget build(BuildContext context) {
    if (versionState is VersionForceUpdate) {
      final forceUpdate = versionState as VersionForceUpdate;
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              forceUpdate.message.isEmpty
                  ? 'Please update the app to continue.'
                  : forceUpdate.message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text(
          'v2 bootstrap loaded:\n\n'
          'Language: ${languageState.appLanguage.displayName}'
          '${languageState.isFirstTime ? ' (first time)' : ''}\n'
          'Theme: ${themeState.themeMode.name}\n'
          'Version check: no update required',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
