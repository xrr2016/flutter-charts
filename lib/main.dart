import 'package:custom_paint/line_chart_page.dart';
import 'package:custom_paint/pie_chart_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LineChartPage(),
    );
  }
}
