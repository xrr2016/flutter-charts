import 'dart:math';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  final List<List<double>> datas;
  final List<double> scores;
  final List features;

  const RadarChart({
    @required this.scores,
    @required this.datas,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: RadarChartPainter(
        datas: widget.datas,
        scores: widget.scores,
        features: widget.features,
        animation: _controller,
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List datas;
  final List scores;
  final List features;
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
    const double scoreLabelFontSize = 12;

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
    // canvas.translate(size.width / 4, size.height / 4);
    canvas.rotate(radius);

    TextPainter(
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
        text: text,
      ),
      textAlign: TextAlign.left,
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
    const double featureLabelFontSize = 16;
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
            yAngle < 0 ? -featureLabelFontSize * 1.5 : featureLabelFontSize / 2;
        double labelXOffset = xAngle < 0
            ? -featureLabelFontWidth * (feature.length + 1)
            : -featureLabelFontWidth;

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
    const graphColors = [Colors.green, Colors.blue];
    var scale = radius / scores.last;

    datas.asMap().forEach(
      (index, graph) {
        var graphPaint = Paint()
          ..color = graphColors[index % graphColors.length].withOpacity(0.3)
          ..style = PaintingStyle.fill;

        var graphOutlinePaint = Paint()
          ..color = graphColors[index % graphColors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..isAntiAlias = true;

        // Start the graph on the initial point
        var scaledPoint = scale * graph[0];
        var path = Path();

        path.moveTo(centerX, centerY - scaledPoint);

        graph.sublist(1).asMap().forEach(
          (index, point) {
            var xAngle = cos(angle * (index + 1) - pi / 2);
            var yAngle = sin(angle * (index + 1) - pi / 2);
            var scaledPoint = scale * point;

            path.lineTo(
                centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
          },
        );

        path.close();
        canvas.drawPath(path, graphPaint);
        canvas.drawPath(path, graphOutlinePaint);
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
