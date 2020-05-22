import 'dart:math' as math;

import 'package:custom_paint/colors.dart';
import 'package:flutter/material.dart';

class PeiPart {
  final double startAngle;
  double sweepAngle;
  final Color color;

  PeiPart(
    this.startAngle,
    this.sweepAngle,
    this.color,
  );

  toMap() {
    return {
      "startAngle": startAngle,
      "sweepAngle": sweepAngle,
      "color": color,
    };
  }
}

class PeiChart extends StatefulWidget {
  final List<double> data;

  const PeiChart({@required this.data});

  @override
  _PeiChartState createState() => _PeiChartState();
}

class _PeiChartState extends State<PeiChart> with TickerProviderStateMixin {
  AnimationController _controller;
  double _total = 0.0;
  final _parts = <PeiPart>[];
  final _animateParts = <PeiPart>[];

  @override
  void initState() {
    super.initState();

    List<double> datas = widget.data;
    _total = datas.reduce((a, b) => a + b);
    double startAngle = 0.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    for (int i = 0; i < datas.length; i++) {
      final data = datas[i];
      final angle = (data / _total) * -math.pi * 2;
      PeiPart peiPart;

      if (i > 0) {
        double lastSweepAngle = _parts[i - 1].sweepAngle;
        startAngle += lastSweepAngle;
        peiPart = PeiPart(startAngle, angle, colors[i]);
      } else {
        peiPart = PeiPart(0.0, angle, colors[i]);
      }

      _parts.add(peiPart);
      _animateParts.add(peiPart);

      final tween = Tween(begin: 0.0, end: peiPart.sweepAngle);
      Animation<double> animation = tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
      );
      _controller.addListener(() {
        _animateParts[i].sweepAngle = animation.value;
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
            painter: PeiChartPainter(
              datas: _animateParts,
            ),
          ),
        ),
        SizedBox(height: 24),
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
  final List<PeiPart> datas;
  PeiChartPainter({@required this.datas});

  double radius = 120.0;

  void drawPart(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    Offset center = Offset(sw / 2, sh / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    for (int i = 0; i < datas.length; i++) {
      final part = datas[i];
      paint.color = part.color;

      canvas.drawArc(rect, part.startAngle, part.sweepAngle, true, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawPart(canvas, size);
  }

  @override
  bool shouldRepaint(PeiChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PeiChartPainter oldDelegate) => false;
}
