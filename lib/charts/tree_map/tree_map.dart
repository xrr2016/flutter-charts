import 'package:flutter/material.dart';

class TreeMap extends StatefulWidget {
  @override
  _TreeMapState createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TreeMapPainter(),
      child: Container(
        width: 500,
        height: 500,
      ),
    );
  }
}

class TreeMapPainter extends CustomPainter {
  void _drawRect(Rect rect, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, paint);
  }

  Rect _generateRect(
    Rect parent,
    int index,
    double current,
    double total, {
    Rect last = null,
  }) {
    double percent = (current / total);
    double width = parent.size.width * percent;
    double left;

    if (index == 0) {
      left == 0.0;
    } else {
      left = last.left + width;
    }
    Rect rect = Rect.fromLTWH(
      left,
      parent.top,
      width,
      parent.size.height,
    );

    return rect;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = Colors.amber;
    canvas.drawRect(rect, paint);

    List<double> datas = [1, 3, 2, 1, 2];
    double total = datas.reduce((value, element) => value + element);

    List<Rect> renderRects = [];
    double lastLeft = 0.0;

    datas.asMap().forEach((key, value) {
      double percent = (value / total);
      double width = rect.size.width * percent;
      double left = key == 0 ? 0.0 : lastLeft + width;

      lastLeft = left;

      Rect r = Rect.fromLTWH(
        left,
        rect.top,
        width,
        rect.size.height,
      );

      renderRects.add(r);
    });

    renderRects.forEach((rect) {
      _drawRect(rect, canvas);
    });

    print(renderRects);
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
