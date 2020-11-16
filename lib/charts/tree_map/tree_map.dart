import 'package:flutter/material.dart';

import './parse_array_to_bst.dart';
import './tree_node.dart';
import './draw_tree_rects.dart';

// 1. 将数据集转成近似平衡的二叉树 √
// 2. 前序遍历二叉树
// 3. 遍历过程中绘制每个字树

class TreeMap extends StatelessWidget {
  final List<double> datas;

  const TreeMap({@required this.datas});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          painter: TreeMapPainter(
            datas: datas,
          ),
          size: constraints.biggest,
        );
      },
    );
  }
}

class TreeMapPainter extends CustomPainter {
  final List<double> datas;

  TreeMapPainter({@required this.datas});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.fill;

    Rect rootRect = Rect.fromLTWH(0, 0, size.width, size.height);
    TreeNode rootNode = parseArrayToBST(datas);
    canvas.drawRect(rootRect, paint);
    drawTreeRects(rootNode, rootRect, rootNode, 0, canvas);
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
