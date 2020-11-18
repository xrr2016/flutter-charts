import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/charts/calender_heatmap/calendar_heatmap.dart';

class CalenderHeatMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<double> datas = List.generate(31, (int index) {
      return Random().nextDouble() * 10;
    }, growable: false);

    return CalenderHeatMap(
      datas: datas,
    );
  }
}
