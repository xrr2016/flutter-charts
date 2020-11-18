import 'package:flutter/material.dart';
import '../charts/area_chart/area_chart.dart';

class AreaChartPage extends StatefulWidget {
  @override
  _AreaChartPageState createState() => _AreaChartPageState();
}

class _AreaChartPageState extends State<AreaChartPage> {
  @override
  Widget build(BuildContext context) {
    return AreaChart(
      datas: [120.0, 90.0, 80.0, 60.0, 108.0],
      // xAxis: ['一月', '二月', '三月', '四月', '五月'],
    );
  }
}
