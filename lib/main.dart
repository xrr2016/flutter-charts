import 'package:flutter/material.dart';

import 'others/animated_path_demo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedPathDemo(),
    );
  }
}
