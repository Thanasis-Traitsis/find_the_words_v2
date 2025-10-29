import 'dart:math';

import 'package:find_the_words/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CircleLayoutDelegate extends FlowDelegate {
  final double radius = 80;
  final double startAngle;
  final Function(Map<int, Offset>)? onPositionsCalculated;

  CircleLayoutDelegate({this.startAngle = -pi / 2, this.onPositionsCalculated});

  @override
  void paintChildren(FlowPaintingContext context) {
    final n = context.childCount;
    final double centerX = context.size.width / 2;
    final double centerY = context.size.height / 2;

    final Map<int, Offset> positions = {};

    if (n > 10) {
      final double centerChildX = centerX - context.getChildSize(0)!.width / 2;
      final double centerChildY = centerY - context.getChildSize(0)!.height / 2;

      positions[0] = Offset(centerChildX, centerChildY);

      context.paintChild(
        0,
        transform: Matrix4.translationValues(centerChildX, centerChildY, 0.0),
      );

      final double angleIncrement = 2 * pi / (n - 1);
      for (int i = 1; i < n; i++) {
        final double angle = startAngle + angleIncrement * (i - 1);
        final double x =
            centerX + radius * cos(angle) - context.getChildSize(i)!.width / 2;
        final double y =
            centerY + radius * sin(angle) - context.getChildSize(i)!.height / 2;

        positions[i] = Offset(x, y);

        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
      }
    } else {
      final double angleIncrement = 2 * pi / n;
      for (int i = 0; i < n; i++) {
        final double angle = startAngle + angleIncrement * i;
        final double x =
            centerX + radius * cos(angle) - context.getChildSize(i)!.width / 2;
        final double y =
            centerY + radius * sin(angle) - context.getChildSize(i)!.height / 2;

        positions[i] = Offset(x, y);

        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
      }
    }

    onPositionsCalculated?.call(positions);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;

  @override
  Size getSize(BoxConstraints constraints) {
    final double totalDiameter = (radius + maxChildSize / 2) * 2;
    return Size(totalDiameter, totalDiameter);
  }

  double get maxChildSize => AppSizes.stageLetter;
}
