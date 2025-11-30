import 'package:flutter/material.dart';

class CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double borderWidth;
  const CustomThumbShape({this.thumbRadius = 12.0, this.borderWidth = 3.0});
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius + borderWidth);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    // Gambar lingkaran luar (border putih)
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius + borderWidth, borderPaint);
    // Gambar lingkaran dalam (warna merah)
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, thumbPaint);
  }
}
