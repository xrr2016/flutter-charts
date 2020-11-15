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

void _drawEvenLevel() {}
void _drawOddLevel() {}

void drawTreeLeftRects(
  TreeNode node,
  Rect rootRectLeft,
  TreeNode rootNodeLeft,
  int levelLeft,
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

  if (levelLeft.isEven) {
    print({
      'even': true,
      'node': node.value,
      'node.left': node.left.value,
      'node.right': node.right.value,
    });

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

    _drawText(
      node.left.value,
      canvas,
      Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
    );
    left = rootRectLeft.left;
    top = rootRectLeft.top + height;
    width = rootRectLeft.width;
    height = (node.right.value / rootNodeLeft.value) * rootRectLeft.height;

    rectRight = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectRight, paint);
    _drawText(
      node.right.value,
      canvas,
      Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
    );
  } else {
    print({
      'odd': true,
      'node': node.value,
      'node.left': node.left.value,
      'node.right': node.right.value,
    });

    double left;
    double width;
    double top = rootRectLeft.top;
    double height = rootRectLeft.height;

    // left node
    left = rootRectLeft.left;
    width = (node.left.value / rootNodeLeft.value) * rootRectLeft.width;
    rectLeft = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectLeft, paint);
    _drawText(
      node.left.value,
      canvas,
      Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
    );

    top = rootRectLeft.top;
    height = rootRectLeft.height;
    left = rootRectLeft.left + width;
    width = (node.right.value / rootNodeLeft.value) * rootRectLeft.width;
    rectRight = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rectRight, paint);

    // if (node.left == null && node.right == null) {
    //   _drawText(
    //     node.right.value,
    //     canvas,
    //     Offset(left + width / 2 - 12.0, top + height / 2 - 12.0),
    //   );
    // }
  }

  levelLeft++;
  drawTreeLeftRects(
    node.left,
    rectLeft,
    node.left,
    levelLeft,
    canvas,
  );

  drawTreeLeftRects(
    node.right,
    rectRight,
    node.right,
    levelLeft,
    canvas,
  );
}
