import 'package:custom_paint/charts/tree_map/tree_node.dart';
import 'package:flutter/material.dart';

// 1. 将数据集转成近似平衡的二叉树
// 2. 前序遍历二叉树
// 3. 遍历过程中绘制每个字树

import '../../utils/parse_arr_to_binary.dart';
import 'build_bst.dart';

class TreeMap extends StatefulWidget {
  @override
  _TreeMapState createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> {
  @override
  void initState() {
    super.initState();

    List<double> input = [2, 10, 4, 3, 7, 5, 9, 8, 1, 6];
    List<double> output = parseArrToBinary(input);

    TreeNode root = buildBST(output);

    dfs(root);
  }

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
  void _drawRect(Rect rect, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, paint);
  }

  Rect _generateRect(
    Rect parent,
    int index,
    double current,
    double total, {
    Rect last = null,
  }) {
    double percent = (current / total);
    double width = parent.size.width * percent;
    double left;

    if (index == 0) {
      left == 0.0;
    } else {
      left = last.left + width;
    }
    Rect rect = Rect.fromLTWH(
      left,
      parent.top,
      width,
      parent.size.height,
    );

    return rect;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = Colors.amber;
    canvas.drawRect(rect, paint);

    List<double> datas = [1, 3, 2, 1, 2];
    double total = datas.reduce((value, element) => value + element);

    List<Rect> renderRects = [];
    double lastLeft = 0.0;

    datas.asMap().forEach((key, value) {
      double percent = (value / total);
      double width = rect.size.width * percent;
      double left = key == 0 ? 0.0 : lastLeft + width;

      lastLeft = left;

      Rect r = Rect.fromLTWH(
        left,
        rect.top,
        width,
        rect.size.height,
      );

      renderRects.add(r);
    });

    renderRects.forEach((rect) {
      _drawRect(rect, canvas);
    });
  }

  @override
  bool shouldRepaint(TreeMapPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TreeMapPainter oldDelegate) => false;
}
