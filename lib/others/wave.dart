import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircleWaveRoute extends StatefulWidget {
  @override
  _CircleWaveRouteState createState() => _CircleWaveRouteState();
}

class _CircleWaveRouteState extends State<CircleWaveRoute>
    with SingleTickerProviderStateMixin {
  double waveGap = 100.0;
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        print(_animation.value);
        setState(() {});
      });

    _animation = Tween(begin: 0.0, end: waveGap).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: CircleWavePainter(_animation.value),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          controller.forward();
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CircleWavePainter extends CustomPainter {
  final double waveRadius;

  CircleWavePainter(this.waveRadius);

  final Paint wavePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double maxRadius = hypot(centerX, centerY);
    double currentRadius = waveRadius;

    while (currentRadius < maxRadius) {
      canvas.drawCircle(Offset(centerX, centerY), currentRadius, wavePaint);
      // currentRadius += 20.0;
    }
  }

  @override
  bool shouldRepaint(CircleWavePainter oldDelegate) {
    return oldDelegate.waveRadius != waveRadius;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
