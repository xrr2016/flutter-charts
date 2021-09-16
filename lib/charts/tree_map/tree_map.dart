import 'package:flutter/material.dart';

import './parse_array_to_bst.dart';
import './tree_node.dart';
import './draw_tree_rects.dart';

// 1. 将数据集转成近似平衡的二叉树 √
// 2. 前序遍历二叉树
// 3. 遍历过程中绘制每个字树

class TreeMap extends StatefulWidget {
  final List<double> datas;

  const TreeMap({@required this.datas});

  @override
  _TreeMapState createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale;
  Animation<Color> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() {
        print(
          {'scale': _scale.value},
        );
      });

    _scale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _color = ColorTween(begin: Colors.orange, end: Colors.red).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          painter: TreeMapPainter(
            datas: widget.datas,
            scale: _scale,
            color: _color,
          ),
          size: constraints.biggest,
        );
      },
    );
  }
}

class TreeMapPainter extends CustomPainter {
  final List<double> datas;
  final Animation<double> scale;
  final Animation<Color> color;

  TreeMapPainter({
    @required this.datas,
    this.scale,
    this.color,
  }) : super(repaint: scale);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.fill;

    Rect rootRect = Rect.fromLTWH(0, 0, size.width, size.height);
    TreeNode rootNode = parseArrayToBST(datas);
    canvas.drawRect(rootRect, paint);

    drawTreeRects(rootNode, rootRect, rootNode, 0, canvas,
        scale: scale.value, color: color.value);
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
