import 'dart:ui';

import 'package:custom_paint/colors.dart';
import 'package:flutter/material.dart';

class Point {
  final Offset offset;
  final Color color;

  Point(this.offset, this.color);
}

class LineChart extends StatefulWidget {
  final List<double> data;
  final List<String> xAxis;

  const LineChart({
    @required this.data,
    @required this.xAxis,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          painter: LineChartPainter(
            datas: widget.data,
            xAxis: widget.xAxis,
          ),
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                // border: Border.all(
                //   width: 1.0,
                //   color: Colors.grey[300],
                // ),
                ),
          ),
        ),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reset();
              _controller.forward();
            },
          ),
        ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> datas;
  final List<String> xAxis;

  LineChartPainter({
    @required this.datas,
    @required this.xAxis,
  });

  void drawLines(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final gap = sw / datas.length;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

    final points = <Offset>[];

    for (int i = 0; i < datas.length; i++) {
      final data = datas[i];
      final dx = 0.0;
      final dy = sh - data;
      final offset = Offset(dx + gap * i + gap / 2, dy);

      points.add(offset);
    }

    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  void drawPoints(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final gap = sw / datas.length;

    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;

    for (int i = 0; i < datas.length; i++) {
      paint.color = colors[i];
      final data = datas[i];
      final dx = 0.0;
      final dy = sh - data;
      final offset = Offset(dx + gap * i + gap / 2, dy);

      canvas.drawCircle(offset, 5, paint);

      final textOffset = Offset(dx + gap * i + 14, dy - 30);
      TextPainter(
        text: TextSpan(
          text: '$data',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, textOffset);

      final xData = xAxis[i];
      final xOffset = Offset(dx + gap * i + 14, sh);

      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$xData',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, xOffset);
    }
  }

  void drawAxis(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final gap = 10.0;

    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final path = Path()
      ..moveTo(0.0 + gap, 0.0 + gap)
      ..lineTo(0.0 + gap, sh - gap)
      ..lineTo(sw - gap, sh - gap);

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawAxis(canvas, size);
    drawLines(canvas, size);
    drawPoints(canvas, size);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LineChartPainter oldDelegate) => false;
}
