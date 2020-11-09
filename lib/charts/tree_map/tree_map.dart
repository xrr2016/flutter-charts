import 'dart:math';

import 'package:flutter/material.dart';

import '../../colors.dart';
import './parse_array_to_bst.dart';
import './tree_node.dart';

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
  void _drawRect(TreeNode node, Rect parent, Canvas canvas) {
    if (node == null || node.left == null || node.right == null) {
      return;
    }

    Paint parentPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;
    canvas.drawRect(parent, parentPaint);

    TreeNode leftNode = node.left;
    double leftNodeLeft = parent.left;
    double leftNodeTop = parent.top;
    double leftNodeWidth = parent.width;
    double leftNodeHeight = (leftNode.value / node.value) * parent.height;
    Paint leftPaint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.green
      ..style = PaintingStyle.stroke;

    Rect rectLeft = Rect.fromLTWH(
      leftNodeLeft,
      leftNodeTop,
      leftNodeWidth,
      leftNodeHeight,
    );

    canvas.drawRect(rectLeft, leftPaint);
    TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: leftNode.value.toString(),
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.pink,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(
        minWidth: 0,
        maxWidth: 500.0,
      )
      ..paint(canvas, Offset(leftNodeLeft, leftNodeTop));

    TreeNode rightNode = node.right;
    double rightNodeLeft = parent.left;
    double rightNodeTop = parent.top + leftNodeHeight;
    double rightNodeWidth = parent.width;
    double rightNodeHeight = (rightNode.value / node.value) * parent.height;

    Paint rightPaint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    Rect rectRight = Rect.fromLTWH(
      rightNodeLeft,
      rightNodeTop,
      rightNodeWidth,
      rightNodeHeight,
    );
    canvas.drawRect(rectRight, rightPaint);

    TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: rightNode.value.toString(),
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.lime,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(
        minWidth: 0,
        maxWidth: 500.0,
      )
      ..paint(canvas, Offset(rightNodeLeft, rightNodeTop));

    if (leftNode != null) {
      _drawRect(leftNode, rectLeft, canvas);
    }
    if (rightNode != null) {
      _drawRect(rightNode, rectRight, canvas);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect parent = Rect.fromLTWH(0, 0, size.width, size.height);

    List<double> input = [2, 10, 4, 3, 7, 5, 9, 8, 1, 6];
    final TreeNode root = parseArrayToBST(input);

    _drawRect(root, parent, canvas);
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
