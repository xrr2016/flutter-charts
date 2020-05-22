import 'package:flutter/material.dart';

import 'charts/pie_chart.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PeiChart(data: [
          60.0,
          50.0,
          40.0,
          30.0,
          90.0,
        ]),
      ),
    );
  }
}
