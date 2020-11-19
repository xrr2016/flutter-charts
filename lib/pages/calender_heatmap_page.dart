import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/charts/calender_heatmap/calendar_heatmap.dart';

class CalenderHeatMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List<double> datas = List.generate(31, (int index) {
    //   return Random().nextDouble() * 10;
    // }, growable: false);
    List<double> datas = [
      1,
      0,
      2,
      10,
      8,
      4,
      0,
      12,
      5,
      8,
      12,
      12,
      2,
      4,
      6,
      0,
      2,
      2,
    ];

    return CalenderHeatMap(datas: datas);
  }
}
