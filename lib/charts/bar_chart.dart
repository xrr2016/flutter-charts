import 'package:custom_paint/colors.dart';
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
              datas: widget.data,
              xAxis: widget.xAxis,
              animateDatas: _animations,
              animation: _controller,
            ),
          ),
        ),
        SizedBox(height: 48),
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

class BarChartPainter extends CustomPainter {
  final List<double> datas;
  final List<String> xAxis;
  final List<double> animateDatas;
  final Animation<double> animation;

  static double _barGap = 18;
  static double _barWidth = _barGap * 2;
  static double labelFontSize = 12.0;

  BarChartPainter({
    @required this.xAxis,
    @required this.datas,
    @required this.animateDatas,
    this.animation,
  }) : super(repaint: animation);

  void _drawAxis(Canvas canvas, Size size) {
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

  void _drawLabels(Canvas canvas, Size size) {
    final sh = size.height;
    final List<double> yAxisLabels = [];
    final double gap = 50;

    Paint paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0;

    for (int i = 1; i < datas.length + 1; i++) {
      yAxisLabels.add(gap * i);
    }

    yAxisLabels.asMap().forEach((index, label) {
      final double top = sh - label;
      final Offset textOffset =
          Offset(0 - labelFontSize * 3, top - labelFontSize / 2);
      final rect = Rect.fromLTWH(0, top, 4, 1);
      canvas.drawRect(rect, paint);

      TextPainter(
        text: TextSpan(
          text: label.toStringAsFixed(0),
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.black87,
          ),
        ),
        textWidthBasis: TextWidthBasis.longestLine,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: 24,
        )
        ..paint(canvas, textOffset);
    });

    TextPainter(
      text: TextSpan(
        text: '0',
        style: TextStyle(
          fontSize: labelFontSize,
          color: Colors.black87,
        ),
      ),
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )
      ..layout(
        minWidth: 0,
        maxWidth: 24,
      )
      ..paint(canvas, Offset(0 - labelFontSize * 3, sh));
  }

  void _darwBars(Canvas canvas, Size size) {
    final sh = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < animateDatas.length; i++) {
      paint.color = colors[i];
      final double data = animateDatas[i];
      final double top = sh - data;
      final double left = i * _barWidth + (i * _barGap) + _barGap;
      final double textFontSize = 14.0;

      final rect = Rect.fromLTWH(left, top, _barWidth, data);
      final offset = Offset(
          left + _barWidth / 2 - textFontSize * 1.2, top - textFontSize * 2);
      canvas.drawRect(rect, paint);

      TextPainter(
        text: TextSpan(
          text: data.toStringAsFixed(1),
          style: TextStyle(
            fontSize: textFontSize,
            color: paint.color,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: textFontSize * data.toString().length,
        )
        ..paint(canvas, offset);

      final xData = xAxis[i];
      final xOffset = Offset(left + _barWidth / 2 - textFontSize, sh + 12);

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
    _drawAxis(canvas, size);
    _darwBars(canvas, size);
    _drawLabels(canvas, size);
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarChartPainter oldDelegate) => false;
}
