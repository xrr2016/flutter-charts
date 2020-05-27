import 'package:flutter/material.dart';

import 'charts/radar_chart.dart';

class RadarChartPage extends StatefulWidget {
  @override
  _RadarChartPageState createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RadarChart(),
    );
  }
}
