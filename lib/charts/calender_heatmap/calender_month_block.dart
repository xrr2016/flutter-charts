import 'package:flutter/material.dart';

import 'utils.dart';
import 'calender_block.dart';

// 1. 传入年份和月份
// 2. 根据年份和月份计算这个月天数
// 3. 计算这个月的第一天是当前星期的第几天
// 4. 计算这个月有几周
// 5. 根据传入数据渲染月视图

class CSCalenderMonthBlock extends StatefulWidget {
  @override
  _CSCalenderMonthBlockState createState() => _CSCalenderMonthBlockState();
}

class _CSCalenderMonthBlockState extends State<CSCalenderMonthBlock> {
  final int year = 2020;
  final int month = 10;
  final int days = daysInMonth(2020, 10);
  final int week = 1;
  final int weeks = 5;

  @override
  void initState() {
    super.initState();

    print(days);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: CustomPaint(
        painter: CSCalenderMonthBlockPainter(),
      ),
    );
  }
}

class CSCalenderMonthBlockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    List offsets = [];
    double gap = 20.0;
    Offset start = Offset(0.0, 0.0);

    for (int i = 0; i < 31; i++) {
      Offset offset = Offset(start.dx * i + gap, start.dy * i + gap);
      offsets.add(offset);
    }
  }

  @override
  bool shouldRepaint(CSCalenderMonthBlockPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CSCalenderMonthBlockPainter oldDelegate) => false;
}
