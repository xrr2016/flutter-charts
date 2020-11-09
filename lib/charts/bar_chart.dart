import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../colors.dart';

class BarChart extends StatefulWidget {
  final double max;
  final List<Map<String, dynamic>> data;

  const BarChart({
    @required this.data,
    @required this.max,
  });

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: BarChartPainter(
            data: widget.data,
            max: widget.max,
          ),
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final List<String> xAxis;
  final double max;

  BarChartPainter({this.data, this.xAxis, this.max});

  void _drawGrid(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;
    final double vgap = sw / 10;
    final double hgap = sh / 10;

    final Paint paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5;

    for (double i = 0; i <= sw; i += vgap) {
      Offset p1 = Offset(i, 0);
      Offset p2 = Offset(i, sh);
      canvas.drawLine(p1, p2, paint);
    }

    for (double i = 0; i < sh; i += hgap) {
      Offset p1 = Offset(0.0, i);
      Offset p2 = Offset(sw, i);
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;

    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, sh)
      ..lineTo(sw, sh);
    canvas.drawPath(path, paint);
  }

  void _drawXAxis(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;
    final double fontSize = 16.0;
    final double vgap = sw / data.length;
    double val = 0.0;

    for (double i = 0; i <= sw; i += vgap) {
      final Offset offset = Offset(i, sh + fontSize);

      TextPainter(
        text: TextSpan(
          text: val.toInt().toString(),
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: sw)
        ..paint(canvas, offset);
      val += max / data.length;
    }
  }

  void _drawBars(Canvas canvas, Size size) {
    final datas = data;
    final double sh = size.height;
    final double sw = size.width;
    final double topOffset = 30.0;
    final double barGap = 20.0;
    final double barHeright = sh / datas.length - barGap - 10;
    final Paint paint = Paint()..isAntiAlias = true;

    for (var i = 0; i < datas.length; i++) {
      paint.color = colors[i];
      final data = datas[i];
      final double barTop = i * (barHeright + barGap) + topOffset;
      final double barWidth = data["value"] * sw / max;

      Rect bar = Rect.fromLTWH(
        0.0,
        barTop,
        barWidth,
        barHeright,
      );
      canvas.drawRect(bar, paint);

      final double valueFontSize = 16.0;
      final Offset valueOffset =
          Offset(barWidth + valueFontSize, barTop + valueFontSize / 2);

      TextPainter(
        text: TextSpan(
          text: data["value"].toString(),
          style: TextStyle(fontSize: 12.0, color: Colors.black87),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: sw)
        ..paint(canvas, valueOffset);

      final tipWidth = 4.0;
      final double tipTop = barTop + (barHeright / 2);
      final Rect tip = Rect.fromLTWH(-tipWidth, tipTop, tipWidth, 1);
      final Paint tipPaint = Paint()
        ..isAntiAlias = true
        ..color = Colors.black;

      canvas.drawRect(tip, tipPaint);

      final double labelFontSize = 16.0;
      final Offset labelOffset = Offset(
        -40.0,
        tipTop - labelFontSize / 2,
      );

      TextPainter(
        text: TextSpan(
          text: data["label"],
          style: TextStyle(fontSize: 12.0, color: Colors.black87),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: 24)
        ..paint(canvas, labelOffset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawXAxis(canvas, size);
    _drawGrid(canvas, size);
    _drawAxis(canvas, size);
    _drawBars(canvas, size);
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BarChartPainter oldDelegate) => false;
}
