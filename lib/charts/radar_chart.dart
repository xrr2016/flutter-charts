import 'dart:math';
import 'package:custom_paint/colors.dart';
import 'package:custom_paint/utils/create_animated_path.dart';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  final List<double> scores;
  final List<String> features;
  final List<List<double>> datas;

  const RadarChart({
    @required this.datas,
    @required this.scores,
    @required this.features,
  });

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomPaint(
          size: Size(300, 300),
          painter: RadarChartPainter(
            datas: widget.datas,
            scores: widget.scores,
            features: widget.features,
            animation: _controller,
          ),
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

class RadarChartPainter extends CustomPainter {
  final List<String> features;
  final List<double> scores;
  final List<List<double>> datas;
  final Animation<double> animation;

  RadarChartPainter({
    @required this.scores,
    @required this.datas,
    @required this.features,
    @required this.animation,
  }) : super(repaint: animation);

  void _drawOutline(Canvas canvas, Size size) {
    Paint outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    Offset centerOffset = Offset(centerX, centerY);
    double radius = centerX * 0.8;

    canvas.drawCircle(centerOffset, radius, outlinePaint);
  }

  void _drawScores(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    Offset centerOffset = Offset(centerX, centerY);
    double radius = centerX * 0.8;

    double scoreDistance = radius / (scores.length + 1);
    const double scoreLabelFontSize = 10;

    Paint scoresPaint = Paint()
      ..color = Colors.grey[500]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    scores.asMap().forEach((index, score) {
      double scoreRadius = scoreDistance * (index + 1);
      canvas.drawCircle(centerOffset, scoreRadius, scoresPaint);
      TextPainter(
        text: TextSpan(
          text: score.toString(),
          style: TextStyle(color: Colors.grey, fontSize: scoreLabelFontSize),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(
          canvas,
          Offset(
            centerX - scoreLabelFontSize,
            centerY - scoreRadius - scoreLabelFontSize,
          ),
        );
    });
  }

  void _drawRotateText({
    @required Canvas canvas,
    @required Size size,
    @required String text,
    @required Offset offset,
    @required double radius,
    Color color = Colors.black,
    double fontSize = 12.0,
  }) {
    canvas.save();
    canvas.rotate(radius);

    TextPainter(
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
        text: text,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: size.width)
      ..paint(canvas, offset);
    canvas.restore();
  }

  void _drawFetures(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    Offset centerOffset = Offset(centerX, centerY);
    double radius = centerX * 0.8;

    double angle = (2 * pi) / features.length;
    const double featureLabelFontSize = 14;
    const double featureLabelFontWidth = 12;

    features.asMap().forEach(
      (index, feature) {
        double xAngle = cos(angle * index - pi / 2);
        double yAngle = sin(angle * index - pi / 2);

        Offset featureOffset = Offset(
          centerX + radius * xAngle,
          centerY + radius * yAngle,
        );

        Paint linePaint = Paint()
          ..color = Colors.grey[500]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..isAntiAlias = true;

        canvas.drawLine(centerOffset, featureOffset, linePaint);

        double labelYOffset =
            yAngle < 0 ? -featureLabelFontSize * 2.5 : featureLabelFontSize * 2;
        double labelXOffset = xAngle < 0
            ? -featureLabelFontWidth * (feature.length + 1)
            : -featureLabelFontWidth / 1.5;

        _drawRotateText(
          canvas: canvas,
          size: size,
          text: feature,
          radius: 0.0,
          fontSize: featureLabelFontSize,
          offset: Offset(
            featureOffset.dx + labelXOffset,
            featureOffset.dy + labelYOffset,
          ),
        );
      },
    );
  }

  void _drawDatas(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double radius = centerX * 0.8;

    var angle = (2 * pi) / features.length;
    var scale = radius / scores.last;

    datas.asMap().forEach(
      (index, graph) {
        Paint graphPaint = Paint()
          ..color = colors[index % colors.length].withOpacity(0.2)
          ..style = PaintingStyle.fill;

        Color outLineColor = colors[index % colors.length];

        Paint graphOutlinePaint = Paint()
          ..color = outLineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..isAntiAlias = true;

        Path path = Path();
        double scoreSize = 12.0;
        double scaledPoint = scale * graph[0];
        path.moveTo(centerX, centerY - scaledPoint);

        _drawRotateText(
          canvas: canvas,
          size: size,
          text: graph[0].toStringAsFixed(1),
          radius: 0.0,
          fontSize: scoreSize,
          color: outLineColor,
          offset: Offset(centerX, centerY - scaledPoint),
        );

        graph.sublist(1).asMap().forEach(
          (index, point) {
            double scaledPoint = scale * point;
            double xAngle = cos(angle * (index + 1) - pi / 2);
            double yAngle = sin(angle * (index + 1) - pi / 2);
            double x = centerX + scaledPoint * xAngle;
            double y = centerY + scaledPoint * yAngle;

            path.lineTo(x, y);

            _drawRotateText(
              canvas: canvas,
              size: size,
              text: point.toStringAsFixed(1),
              radius: 0.0,
              fontSize: scoreSize,
              color: outLineColor,
              offset: Offset(x - scoreSize, y),
            );
          },
        );

        path.close();
        canvas.drawPath(
          createAnimatedPath(path, animation.value),
          graphPaint,
        );
        canvas.drawPath(
          createAnimatedPath(path, animation.value),
          graphOutlinePaint,
        );
      },
    );
  }

  void paint(Canvas canvas, Size size) {
    _drawOutline(canvas, size);
    _drawScores(canvas, size);
    _drawFetures(canvas, size);
    _drawDatas(canvas, size);
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return false;
  }
}
