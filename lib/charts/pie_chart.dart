import 'dart:math' as math;

import 'package:custom_paint/colors.dart';
import 'package:flutter/material.dart';

class PiePart {
  double sweepAngle;
  final Color color;
  final double startAngle;

  PiePart(this.startAngle, this.sweepAngle, this.color);

  toMap() {
    return {
      "color": color,
      "startAngle": startAngle,
      "sweepAngle": sweepAngle,
    };
  }
}

class PieChart extends StatefulWidget {
  final List<double> data;
  final List<String> legends;

  const PieChart({
    @required this.data,
    @required this.legends,
  });

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with TickerProviderStateMixin {
  double _total = 0.0;
  AnimationController _controller;
  final List<PiePart> _parts = <PiePart>[];
  List<double> _animateDatas = [];

  @override
  void initState() {
    super.initState();

    List<double> datas = widget.data;
    _total = datas.reduce((a, b) => a + b);
    double startAngle = 0.0;

    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    for (int i = 0; i < datas.length; i++) {
      _animateDatas.add(0.0);
      final data = datas[i];
      final angle = (data / _total) * -math.pi * 2;
      PiePart peiPart;

      if (i > 0) {
        double lastSweepAngle = _parts[i - 1].sweepAngle;
        startAngle += lastSweepAngle;
        peiPart = PiePart(startAngle, angle, colors[i]);
      } else {
        peiPart = PiePart(0.0, angle, colors[i]);
      }

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
              parts: _parts,
              datas: _animateDatas,
              legends: widget.legends,
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
  final List<double> datas;
  final List<PiePart> parts;
  final List<String> legends;

  PeiChartPainter({
    @required this.datas,
    @required this.legends,
    @required this.parts,
  });

  double radius = 120.0;

  void drawParts(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    final Offset center = Offset(sw / 2, sh / 2);

    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );
    final paint = Paint()
      ..strokeWidth = 0.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (int i = 0; i < parts.length; i++) {
      final PiePart part = parts[i];
      paint.color = part.color;
      canvas.drawArc(rect, part.startAngle, part.sweepAngle, true, paint);

      final data = datas[i];
      final radians = part.startAngle + part.sweepAngle / 2;
      double x = math.cos(radians) * radius / 2 + sw / 2 - 22;
      double y = math.sin(radians) * radius / 2 + sh / 2;
      final offset = Offset(x, y);

      TextPainter(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: '$data%',
          style: TextStyle(
            fontSize: 12,
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
    final Offset center = Offset(sw / 2, sh / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[300]
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, paint);
  }

  void drawLegends(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;

    for (int i = 0; i < datas.length; i++) {
      final part = parts[i];
      final legend = legends[i];
      final radians = part.startAngle + part.sweepAngle / 2;

      double lx = math.cos(radians) * (radius + 32) + sw / 2 - 12;
      double ly = math.sin(radians) * (radius + 32) + sh / 2 - 4;
      final lOffset = Offset(lx, ly);
      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$legend',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, lOffset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCircle(canvas, size);
    drawParts(canvas, size);
    drawLegends(canvas, size);
  }

  @override
  bool shouldRepaint(PeiChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PeiChartPainter oldDelegate) => false;
}
