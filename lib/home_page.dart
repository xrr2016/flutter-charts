import 'package:flutter/material.dart';

import './pages/bar_chart_page.dart';
import './pages/column_chart_page.dart';
import './pages/line_chart_page.dart';
import './pages/pie_chart_page.dart';
import './pages/radar_chart_page.dart';
import './pages/tree_map_page.dart';
import './pages/donut_chart_page.dart';
import './pages/area_chart_page.dart';
import './pages/calender_heatmap_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tab> _tabs = <Tab>[
    Tab(child: Text('日历热力图')),
    Tab(child: Text('面积图')),
    Tab(child: Text('环形图')),
    Tab(child: Text('矩形树图')),
    Tab(child: Text('条形图')),
    Tab(child: Text('柱状图')),
    Tab(child: Text('饼图')),
    Tab(child: Text('折线图')),
    Tab(child: Text('雷达图')),
  ];

  List<Widget> _tabViews = <Widget>[
    CalenderHeatMapPage(),
    AreaChartPage(),
    DonutChartPage(),
    TreeMapPage(),
    BarChartPage(),
    ColumnChartPage(),
    PieChartPage(),
    LineChartPage(),
    RadarChartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabViews.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Charts'),
          bottom: TabBar(
            tabs: _tabs,
            isScrollable: true,
          ),
        ),
        body: TabBarView(children: _tabViews),
      ),
    );
  }
}
