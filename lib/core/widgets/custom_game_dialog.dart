import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_outline_button.dart';
import 'package:flutter/material.dart';

class CustomGameDialog extends StatelessWidget {
  final Widget headerWidget;
  final Widget contentWidget;

  const CustomGameDialog({
    super.key,
    required this.headerWidget,
    required this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingL),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.spacingM,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget,
              contentWidget,
              Align(
                alignment: Alignment.centerRight,
                child: CustomOutlineButton(
                  text: context.translate.gameDialogCloseBtn,
                  onPressed: () {
                    NavigationService.instance.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
