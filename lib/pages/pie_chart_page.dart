import 'package:flutter/material.dart';

import '../charts/pie_chart.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      data: [60.0, 50.0, 40.0, 30.0, 90.0],
      legends: ['一月', '二月', '三月', '四月', '五月'],
    );
  }
}
