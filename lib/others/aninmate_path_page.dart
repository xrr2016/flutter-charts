import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatePathPage extends StatefulWidget {
  @override
  _AnimatePathPageState createState() => _AnimatePathPageState();
}

class _AnimatePathPageState extends State<AnimatePathPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animate Path'),
      ),
      body: Center(
        child: CustomPaint(
          painter: MyPathPainter(_controller),
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Path createAnimatedPath(
  Path originalPath,
  double animationPercent,
) {
  final totalLength = originalPath
      .computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

  final currentLength = totalLength * animationPercent;

  return extractPathUntilLength(originalPath, currentLength);
}

Path extractPathUntilLength(
  Path originalPath,
  double length,
) {
  var currentLength = 0.0;
  final path = Path();
  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;
    var nextLength = currentLength + metric.length;
    final isLastSegment = nextLength > length;

    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);
      path.addPath(pathSegment, Offset.zero);

      break;
    } else {
      // There might be a more efficient way of extracting an entire path
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}

class MyPathPainter extends CustomPainter {
  final Animation<double> animation;

  MyPathPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final sw = size.width;
    final sh = size.height;
    Path originalPath = Path()
      ..moveTo(sw / 2, 0)
      ..lineTo(sw / 2, sh);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    canvas.drawPath(createAnimatedPath(originalPath, animation.value), paint);
  }

  @override
  bool shouldRepaint(MyPathPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyPathPainter oldDelegate) => false;
}
