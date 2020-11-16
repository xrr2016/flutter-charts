import 'dart:math';
import 'package:flutter/material.dart';

import '../../colors.dart';
import './tree_node.dart';

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
      color: Colors.white,
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

void drawTreeRects(
  TreeNode node,
  Rect rootRectLeft,
  TreeNode rootNodeLeft,
  int level,
  Canvas canvas,
) {
  if (node == null) {
    return;
  }
  if (node.left == null && node.right == null) {
    return;
  }

  Paint paint = Paint()
    ..style = PaintingStyle.fill
    ..color = colors[Random().nextInt(colors.length)]
    ..isAntiAlias = true;

  Paint linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..isAntiAlias = true;

  Rect rectLeft;
  Rect rectRight;

  if (level.isEven) {
    double left;
    double top;
    double width;
    double height;

    top = rootRectLeft.top;
    left = rootRectLeft.left;
    width = rootRectLeft.width;
    height = (node.left.value / rootNodeLeft.value) * rootRectLeft.height;
    rectLeft = Rect.fromLTWH(left, top, width, height);

    if (node.left.left == null && node.left.right == null) {
      canvas.drawRect(rectLeft, paint);
      canvas.drawRect(rectLeft, linePaint);

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

    if (node.right.left == null && node.right.right == null) {
      canvas.drawRect(rectRight, paint);
      canvas.drawRect(rectRight, linePaint);

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

    if (node.left.left == null && node.left.right == null) {
      canvas.drawRect(rectLeft, paint);
      canvas.drawRect(rectLeft, linePaint);

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

    if (node.left.left == null && node.left.right == null) {
      canvas.drawRect(rectRight, paint);
      canvas.drawRect(rectRight, linePaint);

      _drawText(
        node.right.value,
        canvas,
        Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
      );
    }
  }

  level++;

  drawTreeRects(
    node.left,
    rectLeft,
    node.left,
    level,
    canvas,
  );

  drawTreeRects(
    node.right,
    rectRight,
    node.right,
    level,
    canvas,
  );
}
