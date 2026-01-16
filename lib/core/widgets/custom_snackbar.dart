import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/config/theme/snackbar_theme.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';

class CustomSnackbar extends StatefulWidget {
  final String? title;
  final String? message;
  final SnackbarTheme theme;
  final VoidCallback onComplete;

  const CustomSnackbar({
    super.key,
    this.title,
    this.message,
    required this.theme,
    required this.onComplete,
  });

  @override
  State<CustomSnackbar> createState() => CustomSnackbarState();
}

class CustomSnackbarState extends State<CustomSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(Duration(seconds: 4), () {
      _dismissSnackbar();
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onComplete();
      }
    });
  }

  void _dismissSnackbar() {
    if (_controller.isAnimating || _controller.isDismissed) return;
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSpacing.snackbarBottomSpacing,
      left: AppSpacing.screenPadding,
      right: AppSpacing.screenPadding,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.spacingL),
              decoration: BoxDecoration(
                color: widget.theme.backgroundColor(context),
                border: Border.all(
                  color: widget.theme.contentColor(context),
                  width: AppBorders.mediumBorderWidth,
                ),
                borderRadius: AppBorders.regularBorderRadius,
              ),
              child: Row(
                spacing: AppSpacing.spacingM,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minWidth: AppSizes.iconM,
                      minHeight: AppSizes.iconM,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.spacingS),
                    decoration: BoxDecoration(
                      color: widget.theme.contentColor(context),
                      borderRadius: AppBorders.smallBorderRadius,
                    ),
                    child: CustomSvgIcon(
                      icon: widget.theme.icon(),
                      color: widget.theme.backgroundColor(context),
                      height: AppSizes.iconXXS,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: AppSpacing.spacingM,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null)
                          CustomText(
                            widget.title!.toUpperCase(),
                            textStyle: TextStyle(
                              fontSize: CustomTextType.regularBody.fontSize,
                              fontWeight: FontWeight.bold,
                              color: widget.theme.contentColor(context),
                              height: 1,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        if (widget.message != null)
                          CustomText(
                            widget.message!,
                            textStyle: TextStyle(
                              fontSize: CustomTextType.regularBody.fontSize,
                              color: widget.theme.contentColor(context),
                              height: 1,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismissSnackbar,
                    child: CustomSvgIcon(
                      icon: CustomIcons.close,
                      color: widget.theme.contentColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomSnackbar(
  BuildContext context,
  String? title,
  String? message,
  SnackbarTheme theme,
) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => CustomSnackbar(
      title: title,
      message: message,
      theme: theme,
      onComplete: () => overlayEntry.remove(),
    ),
  );

  overlay.insert(overlayEntry);
}
