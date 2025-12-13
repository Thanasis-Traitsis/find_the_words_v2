import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WordRowItem extends StatefulWidget {
  final String word;
  final List<dynamic> meanings;

  const WordRowItem({super.key, required this.word, required this.meanings});

  @override
  State<WordRowItem> createState() => _WordRowItemState();
}

class _WordRowItemState extends State<WordRowItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: AppBorders.smallBorderWidth,
              color: context.colors.black,
            ),
          ),
        ),
        child: Column(
          spacing: AppSpacing.spacingM,
          children: [
            Row(
              spacing: AppSpacing.spacingM,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    widget.word,
                    textType: CustomTextType.smallHeading,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(
                    milliseconds: AppValues.wordAnimationDuration,
                  ),
                  child: CustomSvgIcon(
                    icon: CustomIcons.arrowDown,
                    color: context.colors.text,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(
                milliseconds: AppValues.wordAnimationDuration,
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingM,
                ),
                child: Column(
                  children: widget.meanings.map((meaningMap) {
                    final word = meaningMap["word"] ?? "";
                    final definition = meaningMap["meanings"];

                    final List<String> definitions = definition is String
                        ? [definition]
                        : (definition is List ? definition.cast<String>() : []);

                    return _isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.spacingS,
                            ),
                            child: Column(
                              spacing: AppSpacing.spacingS,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (word.isNotEmpty)
                                  CustomText(
                                    "$word:",
                                    textType: CustomTextType.smallHeading,
                                  ),
                                ...definitions.map(
                                  (def) => Html(
                                    data: def,
                                    style: {
                                      "body": Style(
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                        fontSize: FontSize(
                                          CustomTextType.regularBody.fontSize,
                                        ),
                                        color: context.colors.text,
                                      ),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
                  }).toList(),
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
