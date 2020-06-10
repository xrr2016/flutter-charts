import 'dart:math' as math;

import 'package:custom_paint/colors.dart';
import 'package:flutter/material.dart';

class PiePart {
  double sweepAngle;
  final Color color;
  final double startAngle;

  PiePart(
    this.startAngle,
    this.sweepAngle,
    this.color,
  );
}

class PieChart extends StatefulWidget {
  final List<double> datas;
  final List<String> legends;

  const PieChart({
    @required this.datas,
    @required this.legends,
  });

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with TickerProviderStateMixin {
  double _total = 0.0;
  AnimationController _controller;
  List<double> _animateDatas = [];
  final List<PiePart> _parts = <PiePart>[];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..forward();

    List<double> datas = widget.datas;
    // 计算出数据总和
    _total = datas.reduce((a, b) => a + b);
    // 设置一个起始变量
    double startAngle = 0.0;

    for (int i = 0; i < datas.length; i++) {
      _animateDatas.add(0.0);
      final data = datas[i];
      // 计算出每个数据所占的弧度值
      final angle = (data / _total) * -math.pi * 2;
      PiePart peiPart;

      if (i > 0) {
        // 下一个数据的起始弧度值等于之前的弧度值相加
        double lastSweepAngle = _parts[i - 1].sweepAngle;
        startAngle += lastSweepAngle;
        peiPart = PiePart(startAngle, angle, colors[i]);
      } else {
        // 第一个数据的起始弧度为 0.0
        peiPart = PiePart(0.0, angle, colors[i]);
      }
      // 添加到数组中
      _parts.add(peiPart);

      CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      );

      final partTween = Tween<double>(begin: 0.0, end: peiPart.sweepAngle);
      Animation<double> animation = partTween.animate(curvedAnimation);

      final percentTween = Tween<double>(begin: 0.0, end: data);
      Animation<double> percentAnimation =
          percentTween.animate(curvedAnimation);

      _controller.addListener(() {
        _parts[i].sweepAngle = animation.value;
        _animateDatas[i] =
            double.parse(percentAnimation.value.toStringAsFixed(1));
        setState(() {});
      });
    }
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
            // 将数据传给 PeiChartPainter
            painter: PeiChartPainter(
              total: _total,
              parts: _parts,
              datas: widget.datas,
              legends: widget.legends,
            ),
          ),
        ),
        SizedBox(height: 80),
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

class PeiChartPainter extends CustomPainter {
  final double total;
  final List<double> datas;
  final List<PiePart> parts;
  final List<String> legends;

  PeiChartPainter({
    @required this.total,
    @required this.datas,
    @required this.legends,
    @required this.parts,
  });

  void drawParts(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final double fontSize = 10.0;
    final double radius = math.min(sw, sh) / 2;
    final Offset center = Offset(sw / 2, sh / 2);

    // 创建弧形依照的矩形
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );
    // 设置绘制属性
    final paint = Paint()
      ..strokeWidth = 0.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (int i = 0; i < parts.length; i++) {
      final PiePart part = parts[i];
      // 设置每部分的颜色
      paint.color = part.color;
      // 使用 drawArc 方法画出弧形，参数依次是依照的矩形，起始弧度值，占据的弧度值，是否从中心点绘制，绘制属性
      canvas.drawArc(rect, part.startAngle, part.sweepAngle, true, paint);

      final double data = datas[i];
      // 计算每部分占比
      final String percent = (data / total * 100).toStringAsFixed(1);
      final double radians = part.startAngle + part.sweepAngle / 2;
      // 使用三角函数计算文字位置
      double x = math.cos(radians) * radius / 2 + sw / 2 - fontSize * 3;
      double y = math.sin(radians) * radius / 2 + sh / 2;
      final Offset offset = Offset(x, y);

      // 使用 TextPainter 绘制文字标识
      TextPainter(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: '$data $percent%',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, offset);
    }
  }

  void drawCircle(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    // 确定圆的半径
    final double radius = math.min(sw, sh) / 2;
    // 定义中心点
    final Offset center = Offset(sw / 2, sh / 2);

    // 定义圆形的绘制属性
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    // 使用 Canvas 的 drawCircle 绘制
    canvas.drawCircle(center, radius, paint);
  }

  void drawLegends(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final double radius = math.min(sw, sh) / 2;
    final double fontSize = 12.0;

    for (int i = 0; i < datas.length; i++) {
      final PiePart part = parts[i];
      final String legend = legends[i];
      // 根据每部分的起始弧度加上自身弧度值的一半得到每部分的中间弧度值
      final radians = part.startAngle + part.sweepAngle / 2;
      // 根据三角函数计算中出标识文字的 x 和 y 位置，需要加上宽和高的一半适配 Canvas 的坐标
      double x = math.cos(radians) * (radius + 32) + sw / 2 - fontSize;
      double y = math.sin(radians) * (radius + 32) + sh / 2;
      final offset = Offset(x, y);

      // 使用 TextPainter 绘制文字标识
      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: legend,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCircle(canvas, size);
    drawLegends(canvas, size);
    drawParts(canvas, size);
  }

  @override
  bool shouldRepaint(PeiChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PeiChartPainter oldDelegate) => false;
}
