import 'package:flutter/material.dart';
import 'package:flutter_charts/utils/draw_grid.dart';

import './utils.dart';

enum HEAT_LEVEL {
  NONE,
  LOW,
  NORMAL,
  HIGH,
}

extension HEAT_LEVEL_VALUE on HEAT_LEVEL {
  double value() {
    switch (this) {
      case HEAT_LEVEL.NONE:
        return 0.0;
      case HEAT_LEVEL.LOW:
        return 0.4;
      case HEAT_LEVEL.NORMAL:
        return 0.6;
      case HEAT_LEVEL.HIGH:
        return 1.0;
      default:
        return 0.0;
    }
  }
}

class CalenderHeatMap extends StatelessWidget {
  static final DateTime now = DateTime.now();

  final List<double> datas;
  final int totalDays;

  const CalenderHeatMap({
    @required this.datas,
    this.totalDays = 31,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          painter: CalenderHeatMapPainter(),
          size: constraints.biggest,
        );
      },
    );
  }
}

class CalenderHeatMapPainter extends CustomPainter {
  final double blockWidth = 25.0;
  final double blockHeight = 25.0;
  final double blockRadius = 5.0;
  final double gap = 5.0;

  Color _generateBlockColor({double opacity = 1}) {
    return Color.fromRGBO(45, 181, 93, opacity);
  }

  void _drawBlock(Canvas canvas, double left, double top) {
    final Paint paint = Paint()
      ..color = Colors.black12
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
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
    // drawGrid(canvas, size);
    _drawWeekDayTexts(canvas, size);
    Offset start = Offset(100.0, 0.0);
    final Paint paint = Paint()
      ..color = Colors.black12
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    DateTime firstDay = DateTime(2020, 7, 1);
    // int days = daysInMonth(2020, 11);
    int wholeMonthDays = 7 * 5;

    canvas.save();
    canvas.translate(0, size.height / 4);

    for (int i = 1; i <= wholeMonthDays; i++) {
      final Rect rect =
          Rect.fromLTWH(start.dx, start.dy, blockWidth, blockHeight);
      final Radius radius = Radius.circular(blockRadius);
      final rrect = RRect.fromRectAndRadius(rect, radius);

      canvas.drawRRect(rrect, paint);

      Offset move;
      if (i % 7 == 0) {
        move = Offset(gap + blockWidth, -start.dy);
        start += move;
      } else {
        move = Offset(0, gap + blockHeight);
        start += move;
      }
      if (i >= firstDay.weekday - 1) {
        paint.color = Color.fromRGBO(45, 181, 93, 1);
      } else {
        paint.color = Colors.black12;
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CalenderHeatMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CalenderHeatMapPainter oldDelegate) => false;
}
