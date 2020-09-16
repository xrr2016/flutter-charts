import 'package:custom_paint/charts/bar_chart.dart';
import 'package:flutter/material.dart';

class BarChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      max: 6000.0,
      data: [
        {
          "label": "中国",
          "value": 2800.0,
        },
        {
          "label": "印度",
          "value": 3000.0,
        },
        {
          "label": "美国",
          "value": 2200.0,
        },
        {
          "label": "巴西",
          "value": 3800.0,
        },
        {
          "label": "法国",
          "value": 5200.0,
        },
      ],
    );
  }
}
