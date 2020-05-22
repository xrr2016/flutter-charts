import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RadialProgress extends StatefulWidget {
  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;

  @override
  void initState() {
    super.initState();

    percentageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          percentage = lerpDouble(
            percentage,
            newPercentage,
            percentageAnimationController.value,
          );
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200.0,
          width: 200.0,
          child: CustomPaint(
            painter: MyPainter(
              lineColor: Colors.grey,
              completeColor: Colors.green,
              completePercent: percentage,
              width: 8.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.blue,
                shape: CircleBorder(),
                child: Text(
                  "Click",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  percentage = newPercentage;
                  newPercentage += 10.0;
                  if (percentage > 100.0) {
                    percentage = 0.0;
                    newPercentage = 0.0;
                  }
                  percentageAnimationController.forward(from: 0.0);
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  MyPainter({
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      complete,
    );
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyPainter oldDelegate) => false;
}
