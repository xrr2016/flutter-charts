import 'package:flutter/material.dart';
import 'package:flutter_charts/colors.dart';
import '../../utils/draw_grid.dart';

class AreaChart extends StatefulWidget {
  final List<double> datas;

  const AreaChart({@required this.datas});

  @override
  _AreaChartState createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InteractiveViewer(
          child: CustomPaint(
            size: constraints.biggest,
            painter: AreaChartPainter(widget.datas),
          ),
        );
      },
    );
  }
}

class AreaChartPainter extends CustomPainter {
  final List<double> datas;

  AreaChartPainter(this.datas);

  void _drawLines(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final gap = sw / datas.length;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.5;

    canvas.save();
    canvas.translate(0, sh);
    canvas.scale(1, -1);

    Offset p1 = Offset(100, 100);
    Offset p2 = Offset(200, 200);
    canvas.drawLine(p1, p2, paint);

    final path = Path()..moveTo(gap / 2, datas[0]);

    for (int i = 1; i < datas.length; i++) {
      final data = datas[i];
      final x = gap * i + gap / 2;
      final y = sh - data;

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = Colors.black12;
    canvas.clipRect(Offset.zero & size);
    drawGrid(canvas, size);
    _drawLines(canvas, size);

    // canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(AreaChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(AreaChartPainter oldDelegate) => false;
}
