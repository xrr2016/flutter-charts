import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/colors.dart';

class DonutCahrt extends StatefulWidget {
  final List<Map<String, dynamic>> datas;

  const DonutCahrt({this.datas});

  @override
  _DonutCahrtState createState() => _DonutCahrtState();
}

class _DonutCahrtState extends State<DonutCahrt> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: constraints.biggest,
          painter: DonutChartPainter(widget.datas),
        );
      },
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> datas;

  DonutChartPainter(this.datas);

  double initStartAngle = 0.0;

  void _drawBackgroudArc(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 40.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    Rect rect = Rect.fromCircle(
      radius: 100.0,
      center: Offset(size.width / 2, size.height / 2),
    );

    double startAngle = 0 / pi;
    double sweepAngle = 180 / pi;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  void _drawItemArc(
    double value,
    total,
    double startAngle,
    int index,
    Canvas canvas,
    Size size,
  ) {
    Paint paint = Paint()
      ..color = colors[index % colors.length]
      ..strokeWidth = 40.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    Rect rect = Rect.fromCircle(
      radius: 100.0,
      center: Offset(size.width / 2, size.height / 2),
    );

    double sweepAngle = -value / total * pi * 2;
    initStartAngle = startAngle + sweepAngle;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  void _drawTotalText(double total, Canvas canvas, Offset center) {
    TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = TextSpan(
        text: total.toString(),
        style: TextStyle(
          fontSize: 32.0,
          color: Colors.black,
        ),
      )
      ..layout(
        minWidth: 0.0,
        maxWidth: 100.0,
      )
      ..paint(canvas, Offset(center.dx - 32.0, center.dy - 16.0));
  }

  @override
  void paint(Canvas canvas, Size size) {
    var total = 0.0;
    Offset center = Offset(size.width / 2, size.height / 2);
    datas.forEach((item) {
      total += item['value'];
    });

    _drawBackgroudArc(canvas, size);
    _drawTotalText(total, canvas, center);
    datas.asMap().forEach((index, item) {
      _drawItemArc(item['value'], total, initStartAngle, index, canvas, size);
    });
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DonutChartPainter oldDelegate) => false;
}
