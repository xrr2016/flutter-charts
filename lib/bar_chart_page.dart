import 'package:flutter/material.dart';

import 'charts/bar_chart.dart';

class BarChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('柱状图')),
      body: Center(
        child: BarChart(
          data: [120.0, 90.0, 80.0, 60.0, 108.0],
          xAxis: ['一月', '二月', '三月', '四月', '五月'],
        ),
      ),
    );
  }
}
