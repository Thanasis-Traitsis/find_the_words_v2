import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final bool withPadding;
  final bool showOverlay;
  final List<GlobalKey>? overlayWidgetKeys;
  final VoidCallback? onOverlayTap;

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
            child: _SelectiveOverlay(
              widgetKeys: overlayWidgetKeys!,
              overlayColor: context.colors.black.withValues(alpha: 0.5),
              onDarkAreaTap: onOverlayTap,
            ),
          ),
      ],
    );
  }
}

class _SelectiveOverlay extends SingleChildRenderObjectWidget {
  final List<GlobalKey> widgetKeys;
  final Color overlayColor;
  final VoidCallback? onDarkAreaTap;

  const _SelectiveOverlay({
    required this.widgetKeys,
    required this.overlayColor,
    this.onDarkAreaTap,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSelectiveOverlay(
      widgetKeys: widgetKeys,
      overlayColor: overlayColor,
      onDarkAreaTap: onDarkAreaTap,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSelectiveOverlay renderObject,
  ) {
    renderObject
      ..widgetKeys = widgetKeys
      ..overlayColor = overlayColor
      ..onDarkAreaTap = onDarkAreaTap;
  }
}

class _RenderSelectiveOverlay extends RenderBox {
  List<GlobalKey> widgetKeys;
  Color overlayColor;
  VoidCallback? onDarkAreaTap;

  _RenderSelectiveOverlay({
    required this.widgetKeys,
    required this.overlayColor,
    this.onDarkAreaTap,
  });

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final size = this.size;

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    const padding = AppSpacing.spacingXS;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (final key in widgetKeys) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox == null) continue;

      final position = renderBox.localToGlobal(Offset.zero);
      final widgetSize = renderBox.size;

      final widgetRect = Rect.fromLTWH(
        position.dx - (padding / 2),
        position.dy - (padding / 2),
        widgetSize.width + padding,
        widgetSize.height + padding,
      );

      path.addRRect(
        RRect.fromRectAndRadius(
          widgetRect,
          const Radius.circular(AppSpacing.spacingS),
        ),
      );
    }

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    for (final key in widgetKeys) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final widgetPosition = renderBox.localToGlobal(Offset.zero);
        final widgetSize = renderBox.size;
        final rect = Rect.fromLTWH(
          widgetPosition.dx,
          widgetPosition.dy,
          widgetSize.width,
          widgetSize.height,
        );

        if (rect.contains(position)) {
          return false;
        }
      }
    }

    if (onDarkAreaTap != null) {
      onDarkAreaTap!();
    }
    return true;
  }
}
