import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/features/complete/presentation/widgets/stage_completion_section_header.dart';
import 'package:flutter/material.dart';

class StageCompletionWidgetList extends StatelessWidget {
  final String headerTitle;
  final List<Widget> widgetList;

  const StageCompletionWidgetList({
    super.key,
    required this.headerTitle,
    required this.widgetList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingL),
      child: Column(
        spacing: AppSpacing.spacingL,
        children: [
          StageCompletionSectionHeader(
            header: headerTitle,
          ),
          IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgetList
                  .map((widget) => Expanded(child: widget))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
