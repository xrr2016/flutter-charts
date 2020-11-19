import 'dart:math';

import 'package:flutter/material.dart';

import '../../utils/draw_grid.dart';
import './utils.dart';

class CalenderHeatMap extends StatelessWidget {
  final List<double> datas;

  const CalenderHeatMap({
    @required this.datas,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          painter: CalenderHeatMapPainter(datas: datas),
          size: constraints.biggest,
        );
      },
    );
  }
}

class CalenderHeatMapPainter extends CustomPainter {
  final List<double> datas;

  CalenderHeatMapPainter({
    @required this.datas,
  });

  final double gap = 5.0;
  final double blockWidth = 25.0;
  final double blockHeight = 25.0;
  final double blockRadius = 5.0;

  Color _generateBlockColor({double opacity = 1}) {
    if (opacity == 0) {
      return Colors.black12;
    }

    return Color.fromRGBO(45, 181, 93, opacity);
  }

  void _drawBlock(Canvas canvas, Offset offset, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final Rect rect =
        Rect.fromLTWH(offset.dx, offset.dy, blockWidth, blockHeight);
    final Radius radius = Radius.circular(blockRadius);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(rrect, paint);
  }

  void _drawWeekDayTexts(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, size.height / 4);
    Offset start = Offset(30.0, 0.0);

    weekDayTextEn.asMap().forEach((index, text) {
      TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
        ..text = TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        )
        ..layout(
          minWidth: 0.0,
          maxWidth: 100.0,
        )
        ..paint(canvas, start);

      start += Offset(0, gap + blockHeight);
    });
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawGrid(canvas, size);
    _drawWeekDayTexts(canvas, size);

    canvas.save();
    canvas.translate(0, size.height / 4);
    Offset start = Offset(100.0, 0.0);

    for (int i = 0; i < datas.length; i++) {
      Offset move;

      if (i == 0) {
        move = Offset.zero;
      } else {
        if (i % 7 == 0) {
          move = Offset(gap + blockWidth, -start.dy);
        } else {
          move = Offset(0, gap + blockHeight);
        }
      }
      start += move;

      final double val = datas[i];
      final double maxVal = datas.reduce(max);
      final percent = val / maxVal;
      double opacity;

      if (percent > .8) {
        opacity = 1;
      } else if (percent > .6) {
        opacity = 0.8;
      } else if (percent > .4) {
        opacity = 0.6;
      } else if (percent < .2) {
        opacity = 0.4;
      } else {
        opacity = 0.0;
      }

      _drawBlock(canvas, start, _generateBlockColor(opacity: opacity));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CalenderHeatMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CalenderHeatMapPainter oldDelegate) => false;
}
