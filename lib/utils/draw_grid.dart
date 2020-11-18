import 'package:flutter/material.dart';

Paint paint = Paint()
  ..color = Colors.grey
  ..strokeWidth = .5;
final double step = 30; // 小格边长

void drawGrid(Canvas canvas, Size size) {
  canvas.save();
  Offset p1 = Offset(0, 0);
  Offset p2 = Offset(size.width, 0);

  for (double i = 0; i < size.height; i += step) {
    if (i % 90 == 0) {
      paint.color = Colors.black54;
      paint.strokeWidth = 1.0;
    } else {
      paint.color = Colors.black12;
    }
    canvas.drawLine(p1, p2, paint);
    canvas.translate(0, step);
  }

  canvas.restore();

  canvas.save();
  p1 = Offset(0, 0);
  p2 = Offset(0, size.height);

  for (double i = 0; i < size.width; i += step) {
    if (i % 90 == 0) {
      paint.color = Colors.black54;
      paint.strokeWidth = 1.0;
    } else {
      paint.color = Colors.black12;
    }
    canvas.drawLine(p1, p2, paint);
    canvas.translate(step, 0);
  }

  canvas.restore();
}
