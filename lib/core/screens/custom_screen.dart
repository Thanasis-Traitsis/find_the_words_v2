import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({
    super.key,
    this.appBar,
    required this.child,
    this.withPadding = true,
  }) : showOverlay = false,
       overlayWidgetKeys = null,
       onOverlayTap = null;

  const CustomScreen.withOverlay({
    super.key,
    this.appBar,
    required this.child,
    this.withPadding = true,
    required this.showOverlay,
    required List<GlobalKey> this.overlayWidgetKeys,
    this.onOverlayTap,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final bool withPadding;
  final bool showOverlay;
  final List<GlobalKey>? overlayWidgetKeys;
  final VoidCallback? onOverlayTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          backgroundColor: null,
          body: SafeArea(
            child: Padding(
              padding: withPadding
                  ? EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding)
                  : EdgeInsets.zero,
              child: child,
            ),
          ),
        ),

        if (showOverlay &&
            overlayWidgetKeys != null &&
            overlayWidgetKeys!.isNotEmpty)
          Positioned.fill(
            child: GestureDetector(
              onTap: onOverlayTap,
              child: CustomPaint(
                painter: OverlayPainter(
                  widgetKeys: overlayWidgetKeys!,
                  overlayColor: context.colors.black.withValues(alpha: 0.5),
                ),
                child: Container(),
              ),
            ),
          ),
      ],
    );
  }
}

class OverlayPainter extends CustomPainter {
  final List<GlobalKey> widgetKeys;
  final Color overlayColor;

  OverlayPainter({required this.widgetKeys, required this.overlayColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const padding = AppSpacing.spacingS;
    for (final key in widgetKeys) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox == null) {
        continue;
      }

      final position = renderBox.localToGlobal(Offset.zero);
      final widgetSize = renderBox.size;

      final widgetRect = Rect.fromLTWH(
        position.dx - (padding / 2),
        position.dy - (padding / 2),
        widgetSize.width + padding,
        widgetSize.height + padding,
      );

      path.addRRect(
        RRect.fromRectAndRadius(widgetRect, const Radius.circular(8)),
      );
    }

    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
