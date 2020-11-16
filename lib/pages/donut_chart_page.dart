import 'package:flutter/material.dart';
import '../charts/donut_chart.dart';

class DonutChartPage extends StatefulWidget {
  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChartPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DonutCahrt(
        datas: [
          {
            "name": '青年',
            "value": 90.0,
          },
          {
            "name": '少年',
            "value": 40.0,
          },
          {
            "name": '老年',
            "value": 120.0,
          },
          {
            "name": '幼年',
            "value": 200.0,
          },
        ],
      ),
    );
  }
}
