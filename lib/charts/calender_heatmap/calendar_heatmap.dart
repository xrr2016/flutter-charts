import 'package:flutter/material.dart';
import '../../utils/draw_grid.dart';
import 'utils.dart';

class CalenderHeatMap extends StatelessWidget {
  final List<double> datas;

  const CalenderHeatMap({Key key, this.datas}) : super(key: key);

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

  @override
  void paint(Canvas canvas, Size size) {
    // drawGrid(canvas, size);
    Offset start = Offset(10.0, 0.0);
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
        Offset move = Offset(0, gap + blockHeight);
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
