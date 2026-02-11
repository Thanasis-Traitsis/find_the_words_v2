import 'dart:async';

import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/store/presentation/helper/current_boost_helper.dart';
import 'package:flutter/material.dart';

class CountdownTimerTag extends StatefulWidget {
  final Duration? notAvailableUntil;

  const CountdownTimerTag({super.key, required this.notAvailableUntil});

  @override
  State<CountdownTimerTag> createState() => _CountdownTimerTagState();
}

class _CountdownTimerTagState extends State<CountdownTimerTag> {
  Timer? _timer;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.notAvailableUntil;
    _startTimer();
  }

  @override
  void didUpdateWidget(CountdownTimerTag oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.notAvailableUntil != widget.notAvailableUntil) {
      _remainingTime = widget.notAvailableUntil;
      _timer?.cancel();
      _startTimer();
    }
  }

  void _startTimer() {
    if (_remainingTime == null || _remainingTime!.isNegative) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingTime = _remainingTime! - const Duration(seconds: 1);

        if (_remainingTime!.isNegative || _remainingTime!.inSeconds == 0) {
          _remainingTime = Duration.zero;
          timer.cancel();

          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
             getIt<FreezeCubit>().checkAdAvailability();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime == null || _remainingTime!.isNegative) {
      return const SizedBox.shrink();
    }

    return CustomText(
      CurrentBoostHelper.formatDurationWithHours(_remainingTime),
      textType: CustomTextType.smallTag,
      isWhite: true,
    );
  }
}
