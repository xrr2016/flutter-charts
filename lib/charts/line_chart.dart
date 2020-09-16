import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:custom_paint/colors.dart';
import 'package:custom_paint/utils/create_animated_path.dart';

class LineChart extends StatefulWidget {
  final List<double> datas;
  final List<String> xAxis;

  const LineChart({
    @required this.datas,
    @required this.xAxis,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _animationPoints = <double>[];

  @override
  void initState() {
    super.initState();
    double begin = 0.0;
    double end = 4.0;
    List<double> datas = widget.datas;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    final double interval = 1 / datas.length;

    for (int i = 0; i < datas.length; i++) {
      _animationPoints.add(begin);
      final tween = Tween(begin: begin, end: end);

      Animation<double> animation = tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            interval * i,
            interval * i + interval,
            curve: Curves.ease,
          ),
        ),
      );
      _controller.addListener(() {
        _animationPoints[i] = animation.value;
      });
    }

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          painter: LineChartPainter(
            xAxis: widget.xAxis,
            datas: widget.datas,
            animation: _controller,
            points: _animationPoints,
          ),
          child: Container(width: 300, height: 300),
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

class LineChartPainter extends CustomPainter {
  final List<double> datas;
  final List<String> xAxis;
  final List<double> points;
  final Animation<double> animation;

  LineChartPainter({
    @required this.datas,
    @required this.xAxis,
    @required this.points,
    @required this.animation,
  }) : super(repaint: animation);

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
      ..strokeWidth = 1.5;

    final path = Path()..moveTo(gap / 2, sh - datas[0]);

    for (int i = 1; i < datas.length; i++) {
      final data = datas[i];
      final x = gap * i + gap / 2;
      final y = sh - data;

      path.lineTo(x, y);
    }

    canvas.drawPath(createAnimatedPath(path, animation.value), paint);
  }

  void _drawPoints(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final gap = sw / datas.length;

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (int i = 0; i < datas.length; i++) {
      paint.color = colors[i];
      final data = datas[i];
      final dx = 0.0;
      final dy = sh - data;
      final offset = Offset(dx + gap * i + gap / 2, dy);
      canvas.drawCircle(offset, points[i], paint);

      final textOffset = Offset(dx + gap * i + 14, dy - 30);
      TextPainter(
        text: TextSpan(
          text: '$data',
          style: TextStyle(
            fontSize: points[i] * 3,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, textOffset);

      final xData = xAxis[i];
      final double labelFontSize = 12.0;
      final xOffset = Offset(dx + gap * i + labelFontSize, sh + labelFontSize);

      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$xData',
          style: TextStyle(
            fontSize: labelFontSize,
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

  void _drawAxis(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;

    // 设置绘制属性
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    // 创建一个 Path 对象，并规定它的路线
    final Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, sh)
      ..lineTo(sw, sh);
    // 绘制路径
    canvas.drawPath(path, paint);
  }

  void _drawLabels(Canvas canvas, Size size) {
    final double labelFontSize = 12.0;
    final double gap = 50.0;
    final double sh = size.height;
    final List<double> yAxisLabels = [];

    Paint paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0;

    // 使用 50.0 为间隔绘制比传入数据多一个的标识
    for (int i = 0; i <= datas.length; i++) {
      yAxisLabels.add(gap * i);
    }

    yAxisLabels.asMap().forEach(
      (index, label) {
        // 标识的高度为画布高度减去标识的值
        final double top = sh - label;
        final rect = Rect.fromLTWH(0.0, top, 4, 1);
        final Offset textOffset = Offset(
          0 - labelFontSize * 3,
          top - labelFontSize / 2,
        );

        // 绘制 Y 轴右边的线条
        canvas.drawRect(rect, paint);

        // 绘制文字需要用 `TextPainter`，最后调用 paint 方法绘制文字
        TextPainter(
          text: TextSpan(
            text: label.toStringAsFixed(0),
            style: TextStyle(fontSize: labelFontSize, color: Colors.black87),
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr,
          textWidthBasis: TextWidthBasis.longestLine,
        )
          ..layout(minWidth: 0, maxWidth: 24)
          ..paint(canvas, textOffset);
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
    _drawLabels(canvas, size);
    _drawLines(canvas, size);
    _drawPoints(canvas, size);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(LineChartPainter oldDelegate) => false;
}
