import 'dart:math' as math;

import 'package:custom_paint/colors.dart';
import 'package:flutter/material.dart';

class PiePart {
  final double startAngle;
  double sweepAngle;
  final Color color;

  PiePart(
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

class PieChart extends StatefulWidget {
  final List<double> data;
  final List<String> legends;

  const PieChart({
    @required this.data,
    this.legends,
  });

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with TickerProviderStateMixin {
  AnimationController _controller;
  double _total = 0.0;
  final _parts = <PiePart>[];
  final _animateParts = <PiePart>[];

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
      PiePart peiPart;

      if (i > 0) {
        double lastSweepAngle = _parts[i - 1].sweepAngle;
        startAngle += lastSweepAngle;
        peiPart = PiePart(startAngle, angle, colors[i]);
      } else {
        peiPart = PiePart(0.0, angle, colors[i]);
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
              datas: widget.data,
              legends: widget.legends,
              parts: _animateParts,
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
    Offset center = Offset(sw / 2, sh / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      paint.color = part.color;

      canvas.drawArc(rect, part.startAngle, part.sweepAngle, true, paint);
    }
  }

  void drawCircle(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    Offset center = Offset(sw / 2, sh / 2);
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
      final data = datas[i];
      final part = parts[i];
      final legend = legends[i];
      final radians = part.startAngle + part.sweepAngle / 2;

      double x = math.cos(radians) * radius / 2 + sw / 2 - 12;
      double y = math.sin(radians) * radius / 2 + sh / 2;
      final offset = Offset(x, y);

      TextPainter(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: '$data',
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
