import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/features/stage/presentation/help_overlay_cubit/help_overlay_cubit.dart';
import 'package:find_the_words/features/stage/presentation/screens/stage_screen.dart';
import 'package:find_the_words/features/stage/presentation/stage_timer_cubit/stage_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StageScreenProvider extends StatelessWidget {
  final int level;
  final int stage;

  const StageScreenProvider({
    super.key,
    required this.level,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StageTimerCubit(stage, getIt<SharedPreferences>()),
        ),
        BlocProvider(create: (context) => HelpOverlayCubit()),
      ],
      child: StageScreen(level: level, stage: stage),
    );
  }
}
