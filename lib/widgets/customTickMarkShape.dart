import 'package:flutter/material.dart';

class CustomTickMarkShape extends SliderTickMarkShape {
  final double tickMarkRadius;

  const CustomTickMarkShape({this.tickMarkRadius = 4.0});
  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    return Size.fromRadius(tickMarkRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = sliderTheme.activeTickMarkColor ?? Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, tickMarkRadius, paint);
  }
}
