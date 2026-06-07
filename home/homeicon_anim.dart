import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class HomeIconAnimation extends StatelessWidget {
  const HomeIconAnimation({
    super.key,
    required this.progress,
    required this.color,
    this.size = 28,
    this.lineLength = 20,
    this.lineSpacing = 5.5,
    this.strokeWidth = 2.4,
  });

  final Animation<double> progress;
  final Color color;
  final double size;
  final double lineLength;
  final double lineSpacing;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        key: const ValueKey('custom-drawer-icon'),
        painter: _MenuClosePainter(
          progress: progress,
          color: color,
          textDirection: Directionality.of(context),
          lineLength: lineLength,
          lineSpacing: lineSpacing,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _MenuClosePainter extends CustomPainter {
  _MenuClosePainter({
    required this.progress,
    required this.color,
    required this.textDirection,
    required this.lineLength,
    required this.lineSpacing,
    required this.strokeWidth,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;
  final TextDirection textDirection;
  final double lineLength;
  final double lineSpacing;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final value = Curves.easeInOutCubic.transform(progress.value);
    final center = size.center(Offset.zero);
    final direction = textDirection == TextDirection.rtl ? 1.0 : -1.0;
    final openHalfLength = lineLength * 0.4;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawAnimatedLine(
      canvas,
      paint,
      center: center,
      verticalOffset: lerpDouble(-lineSpacing, 0, value)!,
      horizontalOffset: lerpDouble(direction * lineLength * 0.3, 0, value)!,
      angle: lerpDouble(0, math.pi / 4, value)!,
      halfLength: lerpDouble(lineLength * 0.2, openHalfLength, value)!,
    );

    paint.color = color.withValues(alpha: 1 - value);
    final middleHalfLength = (lineLength / 2) * (1 - value);
    canvas.drawLine(
      Offset(center.dx - middleHalfLength, center.dy),
      Offset(center.dx + middleHalfLength, center.dy),
      paint,
    );

    paint.color = color;
    _drawAnimatedLine(
      canvas,
      paint,
      center: center,
      verticalOffset: lerpDouble(lineSpacing, 0, value)!,
      horizontalOffset: lerpDouble(direction * lineLength * 0.2, 0, value)!,
      angle: lerpDouble(0, -math.pi / 4, value)!,
      halfLength: lerpDouble(lineLength * 0.3, openHalfLength, value)!,
    );
  }

  void _drawAnimatedLine(
    Canvas canvas,
    Paint paint, {
    required Offset center,
    required double verticalOffset,
    required double horizontalOffset,
    required double angle,
    required double halfLength,
  }) {
    canvas.save();
    canvas.translate(center.dx + horizontalOffset, center.dy + verticalOffset);
    canvas.rotate(angle);
    canvas.drawLine(Offset(-halfLength, 0), Offset(halfLength, 0), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MenuClosePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.lineLength != lineLength ||
        oldDelegate.lineSpacing != lineSpacing ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
