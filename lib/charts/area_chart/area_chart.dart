import 'package:flutter/material.dart';
import 'package:flutter_charts/colors.dart';

class AreaChart extends StatefulWidget {
  @override
  _AreaChartState createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: constraints.biggest,
          painter: AreaChartPainter(),
        );
      },
    );
  }
}

class AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = colors[0];

    // canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(AreaChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(AreaChartPainter oldDelegate) => false;
}
