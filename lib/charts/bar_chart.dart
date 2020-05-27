import 'package:flutter/material.dart';

class BarChart extends StatefulWidget {
  final List<double> data;
  final List<String> xAxis;

  const BarChart({
    @required this.data,
    @required this.xAxis,
  });

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with TickerProviderStateMixin {
  AnimationController _controller;
  final _animations = <double>[];

  @override
  void initState() {
    super.initState();
    double begin = 0.0;
    List<double> datas = widget.data;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    for (int i = 0; i < datas.length; i++) {
      final end = datas[i];
      final tween = Tween(begin: begin, end: end);
      _animations.add(begin);

      Animation<double> animation = tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
      );
      _controller.addListener(() {
        _animations[i] = animation.value;
        setState(() {});
      });
    }

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: BarChartPainter(
              datas: _animations,
              xAxis: widget.xAxis,
            ),
          ),
        ),
        SizedBox(height: 24),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _controller.reset();
            _controller.forward();
          },
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> datas;
  final List<String> xAxis;

  double _width = 40;
  double _gap = 10;

  BarChartPainter({
    @required this.datas,
    @required this.xAxis,
  });

  void drawAxis(Canvas canvas, Size size) {
    Color lineColor = Colors.black87;
    final sw = size.width;
    final sh = size.height;
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, sh)
      ..lineTo(sw, sh);

    canvas.drawPath(path, paint);
  }

  void darwBar(Canvas canvas, Size size) {
    final sh = size.height;
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (int i = 0; i < datas.length; i++) {
      double data = datas[i];
      double top = sh - data;
      double left = i * _width + (i * _gap) + _gap;

      final rect = Rect.fromLTWH(left, top, _width, data);
      final offset = Offset(left + _width / 2 - 18, top - 20);
      canvas.drawRect(rect, paint);

      TextPainter(
        text: TextSpan(
          text: '$data',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueAccent,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, offset);

      final xData = xAxis[i];
      final xOffset = Offset(left + _width / 2 - 12, sh + 10);

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

  @override
  void paint(Canvas canvas, Size size) {
    drawAxis(canvas, size);
    darwBar(canvas, size);
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarChartPainter oldDelegate) => false;
}
