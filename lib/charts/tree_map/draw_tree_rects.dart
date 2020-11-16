import 'dart:math';
import 'package:flutter/material.dart';

import '../../colors.dart';
import './tree_node.dart';

Paint paint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2.0;

TextPainter textPainter = TextPainter(
  text: TextSpan(),
  textAlign: TextAlign.center,
  textDirection: TextDirection.ltr,
)..layout(
    minWidth: 0.0,
    maxWidth: 100.0,
  );

void _drawText(double value, Canvas canvas, Offset offset) {
  TextSpan textSpan = TextSpan(
    text: value.toString(),
    style: TextStyle(
      fontSize: 24.0,
      color: colors[Random().nextInt(colors.length)],
    ),
  );

  textPainter
    ..text = textSpan
    ..layout(
      minWidth: 0.0,
      maxWidth: 100.0,
    )
    ..paint(canvas, offset);
}

void _drawLeftNode(
    TreeNode node, Rect rootRect, TreeNode rootNode, Canvas canvas) {
  if (node == null) {
    return;
  }

  if (node.left == null && node.right == null) {
    return;
  }

  double left;
  double top;
  double width;
  double height;

  left = rootRect.left;
  width = rootRect.width;
  top = rootRect.top;
  height = (node.left.value / rootNode.value) * rootRect.height;

  Rect rectLeft = Rect.fromLTWH(left, top, width, height);
  canvas.drawRect(rectLeft, paint);

  _drawText(
    node.left.value,
    canvas,
    Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
  );
}

void _drawRihgtNode(TreeNode node) {
  if (node == null) {
    return;
  }
}

int level = 0;

void drawTreeRects(
  TreeNode node,
  Rect rootRectLeft,
  TreeNode rootNodeLeft,
  Canvas canvas,
) {
  if (node == null) {
    return;
  }
  if (node.left == null && node.right == null) {
    return;
  }

  Rect rectLeft;
  Rect rectRight;

  if (level.isEven) {
    double left;
    double top;
    double width;
    double height;

    left = rootRectLeft.left;
    width = rootRectLeft.width;
    top = rootRectLeft.top;
    height = (node.left.value / rootNodeLeft.value) * rootRectLeft.height;

    rectLeft = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectLeft, paint);

    if (node.left.left == null && node.left.right == null) {
      _drawText(
        node.left.value,
        canvas,
        Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
      );
    }

    left = rootRectLeft.left;
    top = rootRectLeft.top + height;
    width = rootRectLeft.width;
    height = (node.right.value / rootNodeLeft.value) * rootRectLeft.height;

    rectRight = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectRight, paint);

    if (node.right.left == null && node.right.right == null) {
      _drawText(
        node.right.value,
        canvas,
        Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
      );
    }
  } else {
    double left;
    double width;
    double top = rootRectLeft.top;
    double height = rootRectLeft.height;

    // left node
    left = rootRectLeft.left;
    width = (node.left.value / rootNodeLeft.value) * rootRectLeft.width;
    rectLeft = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectLeft, paint);

    if (node.left.left == null && node.left.right == null) {
      _drawText(
        node.left.value,
        canvas,
        Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
      );
    }

    top = rootRectLeft.top;
    height = rootRectLeft.height;
    left = rootRectLeft.left + width;
    width = (node.right.value / rootNodeLeft.value) * rootRectLeft.width;
    rectRight = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectRight, paint);
  }

  level++;

  drawTreeRects(
    node.left,
    rectLeft,
    node.left,
    canvas,
  );

  drawTreeRects(
    node.right,
    rectRight,
    node.right,
    canvas,
  );
}
