import 'package:flutter/material.dart';

class CSCalendarBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CSCalendarBlockPainter(),
    );
  }
}

class CSCalendarBlockPainter extends CustomPainter {
  final double blockWidth = 25.0;
  final double blockHeight = 25.0;
  final double blockRadius = 5.0;

  Color _generateBlockColor({double opacity = 1}) {
    return Color.fromRGBO(45, 181, 93, opacity);
  }

  void _drawBlock(Canvas canvas, Size size, double left, double top) {
    final Paint paint = Paint()
      ..color = _generateBlockColor(opacity: 1)
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
    final Radius radius = Radius.circular(blockRadius);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(rrect, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    List offsets = [];
    double gap = 10.0;
    Offset start = Offset(1.0, 1.0);

    for (int i = 0; i < 31; i++) {
      Offset offset = Offset(start.dx * i * (blockWidth + gap), start.dy);
      offsets.add(offset);
    }

    for (int i = 0; i < offsets.length; i++) {
      final Offset offset = offsets[i];
      print(offset.dx);
      _drawBlock(canvas, size, offset.dx, offset.dy);
    }
  }

  @override
  bool shouldRepaint(CSCalendarBlockPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CSCalendarBlockPainter oldDelegate) => false;
}
