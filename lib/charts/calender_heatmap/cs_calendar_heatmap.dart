// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/material.dart';

// import './src/cs_calender_month_block.dart';
import './src/cs_calender_block.dart';

class CSCalendarHeatmap extends StatefulWidget {
  @override
  _CSCalendarHeatmapState createState() => _CSCalendarHeatmapState();
}

class _CSCalendarHeatmapState extends State<CSCalendarHeatmap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CSCalendarBlock(),
    );
  }
}
