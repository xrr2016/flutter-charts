import 'package:custom_paint/line_chart_page.dart';
import 'package:flutter/material.dart';

import 'others/animated_path_demo.dart';
import 'others/aninmate_path_page.dart';

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
