import 'package:flutter/material.dart';

class FlutterLogoPage extends StatefulWidget {
  @override
  _FlutterLogoPageState createState() => _FlutterLogoPageState();
}

class _FlutterLogoPageState extends State<FlutterLogoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaintLogo(),
      ),
    );
  }
}

class CustomPaintLogo extends StatefulWidget {
  @override
  _CustomPaintLogoState createState() => _CustomPaintLogoState();
}

class _CustomPaintLogoState extends State<CustomPaintLogo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: CustomPaint(
        painter: LogoPainter(),
        size: Size(400, 400),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  Color blue0 = Color(0xff70CFF8);
  Color blue1 = Color(0xff57BAF7);
  Color blue2 = Color(0xff255998);
  Color grey = Color(0xff757575);

  @override
  void paint(Canvas canvas, Size size) {
    Path pathZero = Path()
      ..moveTo(0, 127)
      ..lineTo(38, 169)
      ..lineTo(206, 0)
      ..lineTo(125, 0)
      ..close();

    Paint paintZero = Paint()
      ..color = blue0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawPath(pathZero, paintZero);

    Path pathOne = Path()
      ..moveTo(58, 188)
      ..lineTo(98, 151)
      ..lineTo(139, 188)
      ..lineTo(98, 230)
      ..close();

    Paint paintOne = Paint()
      ..color = blue1
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawPath(pathOne, paintOne);

    // canvas.drawPath(pathTwo, paintTwo);

    // canvas.drawPath(pathThree, paintThree);
  }

  @override
  bool shouldRepaint(LogoPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LogoPainter oldDelegate) => false;
}
