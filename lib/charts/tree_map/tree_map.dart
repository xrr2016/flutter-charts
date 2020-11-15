import 'package:flutter/material.dart';

import './parse_array_to_bst.dart';
import './tree_node.dart';
import './draw_tree_rects.dart';

// 1. 将数据集转成近似平衡的二叉树 √
// 2. 前序遍历二叉树
// 3. 遍历过程中绘制每个字树

class TreeMap extends StatefulWidget {
  @override
  _TreeMapState createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TreeMapPainter(),
      child: Container(
        width: 500,
        height: 500,
      ),
    );
  }
}

class TreeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    List<double> input = [2, 10, 4, 3, 7, 5, 9, 8, 1, 6];
    Paint paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.fill;

    Rect rootRect = Rect.fromLTWH(0, 0, size.width, size.height);
    TreeNode rootNode = parseArrayToBST(input);
    canvas.drawRect(rootRect, paint);
    drawTreeLeftRects(rootNode, rootRect, rootNode, 0, canvas);
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
