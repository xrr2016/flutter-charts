import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(),
      size: Size(400, 400),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sw = size.width;
    double sh = size.height;
    double centerX = sw / 2.0;
    double centerY = sh / 2.0;
    Offset center = Offset(centerX, centerY);
    // double maxRadius = math.sqrt(centerX * centerX + centerY * centerY);

    // canvas.drawCircle(center, 160, bgPaint);
    Paint circlePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 4.0
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 200, circlePaint);

    for (int i = 1; i <= 12; i++) {
      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.left,
        textWidthBasis: TextWidthBasis.longestLine,
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(
          minWidth: 0,
          maxWidth: 40,
        );

      final offset = Offset(centerX, 10);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ClockPainter oldDelegate) => false;
}
