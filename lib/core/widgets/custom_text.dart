import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextType textType;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextStyle? textStyle;
  final bool isWhite;
  final bool isItalic;

  const CustomText(
    this.text, {
    this.textType = CustomTextType.regularBody,
    super.key,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.textStyle,
    this.isWhite = false,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ?? textType.getTextStyle(context, isWhite, isItalic),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
