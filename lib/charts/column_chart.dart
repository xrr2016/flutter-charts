import 'package:flutter/material.dart';

import '../colors.dart';

class ColumnChart extends StatefulWidget {
  final List<double> data;
  final List<String> xAxis;

  const ColumnChart({
    @required this.data,
    @required this.xAxis,
  });

  @override
  _ColumnChartState createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final _animations = <double>[];

  @override
  void initState() {
    super.initState();
    double begin = 0.0;
    List<double> datas = widget.data;
    // 初始化动画控制器，并调用 forward 方法启动动画
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )..forward();

    for (int i = 0; i < datas.length; i++) {
      final double end = datas[i];
      // 使用一个补间值 Tween 创建每个矩形的动画值
      final Tween<double> tween = Tween(begin: begin, end: end);
      // 初始化数组里面的值
      _animations.add(begin);

      // 创建补间动画
      Animation<double> animation = tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
      );
      _controller.addListener(() {
        // 使用 setState 更新 _animations 数组里面的动画值
        setState(() {
          _animations[i] = animation.value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          painter: ColumnChartPainter(
            // 最后向 ColumnChartPainter 传入 _animations 数组
            datas: _animations,
            xAxis: widget.xAxis,
            animation: _controller,
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

class ColumnChartPainter extends CustomPainter {
  final List<double> datas;
  final List<String> xAxis;
  final Animation<double> animation;

  static double _barGap = 18;
  static double _barWidth = _barGap * 2;
  static double labelFontSize = 12.0;

  ColumnChartPainter({
    @required this.xAxis,
    @required this.datas,
    this.animation,
  }) : super(repaint: animation);

  void _drawAxis(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;

    // 使用 Paint 定义路径的样式
    final Paint paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 使用 Path 定义绘制的路径，从画布的左上角到左下角在到右下角
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, sh)
      ..lineTo(sw, sh);

    // 使用 drawPath 方法绘制路径
    canvas.drawPath(path, paint);
  }

  void _drawLabels(Canvas canvas, Size size) {
    final double gap = 50.0;
    final double sh = size.height;
    final List<double> yAxisLabels = [];

    Paint paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0;

    // 使用 50.0 为间隔绘制比传入数据多一个的标识
    for (int i = 1; i <= datas.length; i++) {
      yAxisLabels.add(gap * i);
    }

    yAxisLabels.asMap().forEach(
      (index, label) {
        // 标识的高度为画布高度减去标识的值
        final double top = sh - label;
        final rect = Rect.fromLTWH(-4, top, 4, 1);
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

  void _darwBars(Canvas canvas, Size size) {
    final sh = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < datas.length; i++) {
      // 每个矩形使用预设的 colors 数组里面的颜色
      paint.color = colors[i];
      final double textFontSize = 14.0;
      final double data = datas[i];
      // 矩形的上边缘为画布高度减去数据值
      final double top = sh - data;
      // 矩形的左边缘为当前索引值乘以矩形宽度加上矩形之间的间距
      final double left = i * _barWidth + (i * _barGap) + _barGap;

      // 使用 Rect.fromLTWH 方法创建要绘制的矩形
      final rect = Rect.fromLTWH(left, top, _barWidth, data);
      // 使用 drawRect 方法绘制矩形
      canvas.drawRect(rect, paint);

      final offset = Offset(
        left + _barWidth / 2 - textFontSize * 1.2,
        top - textFontSize * 2,
      );
      // 使用 TextPainter 绘制矩形上放的数值
      TextPainter(
        text: TextSpan(
          text: data.toStringAsFixed(1),
          style: TextStyle(fontSize: textFontSize, color: paint.color),
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
      // 绘制横轴标识
      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$xData',
          style: TextStyle(fontSize: 12, color: Colors.black87),
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
    _drawLabels(canvas, size);
    _darwBars(canvas, size);
  }

  @override
  bool shouldRepaint(ColumnChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ColumnChartPainter oldDelegate) => false;
}
