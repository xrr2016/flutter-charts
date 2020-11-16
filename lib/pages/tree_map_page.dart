import 'dart:math';

import '../charts/tree_map/tree_map.dart';
import 'package:flutter/material.dart';

class TreeMapPage extends StatefulWidget {
  @override
  _TreeMapPageState createState() => _TreeMapPageState();
}

class _TreeMapPageState extends State<TreeMapPage> {
  @override
  Widget build(BuildContext context) {
    return TreeMap(datas: [2, 10, 4, 3, 7, 5, 9, 8, 1, 6]);
  }
}
