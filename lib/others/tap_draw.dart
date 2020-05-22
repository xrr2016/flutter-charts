import 'dart:math';

import 'package:flutter/material.dart';

import '../colors.dart';

class TapDraw extends StatefulWidget {
  @override
  _TapDrawState createState() => _TapDrawState();
}

class _TapDrawState extends State<TapDraw> with TickerProviderStateMixin {
  AnimationController controller;

  Offset position;
  Animation<double> width;
  Animation<double> height;
  Animation<double> radius;

  void startAnimation(details) {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    width = Tween(
      begin: 0.0,
      end: Random().nextInt(200).toDouble(),
    ).animate(controller);

    height = Tween(
      begin: 0.0,
      end: Random().nextInt(200).toDouble(),
    ).animate(controller);

    radius = Tween(
      begin: 0.0,
      end: Random().nextInt(100).toDouble(),
    ).animate(controller);

    position = details.globalPosition;
    colors.shuffle();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        startAnimation(details);
      },
      onPanUpdate: (details) {
        startAnimation(details);
      },
      child: Scaffold(
        body: width == null
            ? Container()
            : CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: TapDrawPainter(
                  position: position,
                  width: width?.value ?? 0.0,
                  height: height?.value ?? 0.0,
                  radius: radius?.value ?? 0.0,
                  color: colors.first,
                  bgColor: colors.last,
                ),
              ),
      ),
    );
  }
}

class TapDrawPainter extends CustomPainter {
  final Offset position;
  final double width;
  final double height;
  final double radius;
  final Color color;
  final Color bgColor;

  TapDrawPainter({
    this.position,
    this.width,
    this.height,
    this.radius,
    this.color,
    this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (position == null) return;

    Paint rectPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    Rect rect = Rect.fromCenter(
      center: position,
      width: width,
      height: height,
    );

    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    Paint bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPaint(bgPaint);
    canvas.drawRRect(rRect, rectPaint);
  }

  @override
  bool shouldRepaint(TapDrawPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TapDrawPainter oldDelegate) => false;
}
