import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final Function(String) onChanged;
  final Function() onClearPressed;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.textEditingController,
    required this.onChanged,
    required this.onClearPressed,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    showClearIcon = widget.textEditingController.text.isNotEmpty;
    widget.textEditingController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      showClearIcon = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      onChanged: (query) {
        widget.onChanged(query);

        setState(() {
          showClearIcon = query.isNotEmpty;
        });
      },
      style: TextStyle(fontSize: CustomTextType.regularBody.fontSize),
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingL,
          vertical: AppSpacing.spacingS,
        ),
        border: OutlineInputBorder(borderRadius: AppBorders.bigBorderRadius),
        suffixIcon: showClearIcon
            ? IconButton(
                icon: CustomSvgIcon(icon: 'close', color: context.colors.text),
                onPressed: () {
                  widget.textEditingController.clear();
                  widget.onClearPressed();

                  setState(() {
                    showClearIcon = false;
                  });
                },
              )
            : null,
      ),
    );
  }
}
