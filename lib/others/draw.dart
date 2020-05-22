import 'dart:ui';

import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  final _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onPanStart: (DragStartDetails details) {
            print('start: ${details.localPosition}');
            _points.add(details.localPosition);
            setState(() {});
          },
          onPanUpdate: (DragUpdateDetails details) {
            print('update: ${details.localPosition}');
            _points.add(details.localPosition);
            setState(() {});
          },
          onPanEnd: (DragEndDetails details) {
            print('end: $details');
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: MyPainter(_points),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonBar(
        children: <Widget>[
          IconButton(
            color: Colors.blue,
            icon: Icon(Icons.clear),
            onPressed: () {
              _points.clear();
            },
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Offset> points;

  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    canvas.drawPoints(PointMode.polygon, points, paint);
    // for (var i = 0; i < points.length; i++) {
    //   canvas.drawCircle(points[i], 10.0, paint);
    // }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MyPainter oldDelegate) => false;
}
