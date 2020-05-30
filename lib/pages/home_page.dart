import 'package:custom_paint/pages/bar_chart_page.dart';
import 'package:custom_paint/pages/line_chart_page.dart';
import 'package:custom_paint/pages/pie_chart_page.dart';
import 'package:custom_paint/pages/radar_chart_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tab> _tabs = <Tab>[
    Tab(child: Text('柱状图')),
    Tab(child: Text('饼图')),
    Tab(child: Text('折线图')),
    Tab(child: Text('雷达图')),
  ];

  List<Widget> _tabViews = <Widget>[
    BarChartPage(),
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
          bottom: TabBar(tabs: _tabs),
        ),
        body: TabBarView(children: _tabViews),
      ),
    );
  }
}
