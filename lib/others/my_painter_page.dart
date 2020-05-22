import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyPainterPage extends StatefulWidget {
  @override
  _MyPainterPageState createState() => _MyPainterPageState();
}

class _MyPainterPageState extends State<MyPainterPage>
    with TickerProviderStateMixin {
  double _width = 2.0;
  double _sides = 3.0;
  double _radius = 100.0;
  double _radians = 0.0;

  AnimationController controller;
  Animation<double> rotateAnimation;
  Animation<double> radiusAnimation;
  Animation<double> widthAnimation;
  Animation<double> slideAnimation;
  Animation<Color> colorAnimation;

  Tween<double> _sildeTween = Tween(begin: 2.0, end: 20);
  Tween<double> _widthTween = Tween(begin: 0.0, end: 20.0);
  Tween<double> _radiusTween = Tween(begin: 50.0, end: 200);
  Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi * 2);
  ColorTween _colorTween = ColorTween(begin: Colors.blue, end: Colors.orange);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    rotateAnimation = _rotationTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.2,
        ),
      ),
    );
    slideAnimation = _sildeTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.2,
          0.4,
        ),
      ),
    );
    widthAnimation = _widthTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.4,
          0.6,
        ),
      ),
    );
    radiusAnimation = _radiusTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6,
          0.8,
        ),
      ),
    );
    colorAnimation = _colorTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.8,
          1.0,
        ),
      ),
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polygons')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: CustomPaint(
              painter: ShapePainter(
                widthAnimation.value,
                slideAnimation.value,
                radiusAnimation.value,
                rotateAnimation.value,
                colorAnimation.value,
              ),
              child: Container(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Width'),
          ),
          Slider(
            min: 2.0,
            max: 20.0,
            divisions: 5,
            value: _width,
            label: _width.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _width = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Sides'),
          ),
          Slider(
            value: _sides,
            min: 3.0,
            max: 10.0,
            label: _sides.toInt().toString(),
            divisions: 7,
            onChanged: (value) {
              setState(() {
                _sides = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Radius'),
          ),
          Slider(
            value: _radius,
            min: 10.0,
            max: MediaQuery.of(context).size.width / 2,
            onChanged: (value) {
              setState(() {
                _radius = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Rotation'),
          ),
          Slider(
            value: _radians,
            min: 0.0,
            max: math.pi,
            onChanged: (value) {
              setState(() {
                _radians = value;
              });
            },
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final double width;
  final double sides;
  final double radius;
  final double radians;
  final Color color;

  ShapePainter(
    this.width,
    this.sides,
    this.radius,
    this.radians,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    var path = Path();
    var angle = (math.pi * 2) / sides;
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset startPoint =
        Offset(radius * math.cos(radians), radius * math.sin(radians));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(radians + angle * i) + center.dx;
      double y = radius * math.sin(radians + angle * i) + center.dy;
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
