import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final List<Offset> positions;
  final Offset? currentDragPosition;
  final BuildContext context;
  final int selectedLetters;

  LinePainter({
    required this.context,
    required this.positions,
    required this.selectedLetters,
    this.currentDragPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.isEmpty) return;

    final double lineSize = 4;
    final double centralizer = lineSize * 2;

    final paint = Paint()
      ..color = context.colors.primary
      ..strokeWidth = lineSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(
      positions.first.dx - centralizer,
      positions.first.dy - centralizer,
    );

    for (int i = 1; i < positions.length; i++) {
      path.lineTo(positions[i].dx - centralizer, positions[i].dy - centralizer);
    }

    if (currentDragPosition != null && positions.isNotEmpty) {
      path.lineTo(currentDragPosition!.dx, currentDragPosition!.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.currentDragPosition != currentDragPosition;
  }
}
