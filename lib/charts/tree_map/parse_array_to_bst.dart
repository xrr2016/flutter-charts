// eg:
//   List<int> input = [2, 10, 4, 3, 7, 5, 9, 8, 1, 6];
//   List<int> output = [0, 2, 12, 16, 19, 26, 31, 40, 48, 49,55];

import './tree_node.dart';

TreeNode parseArrayToBST(List<double> array) {
  int n = array.length;
  double sum = 0.0;
  List<double> sums = List(n + 1);
  sums[0] = 0.0;

  for (int i = 0; i < n; i++) {
    sum += array[i];
    sums[i + 1] = sum;
  }

  final TreeNode root = TreeNode(sums.last);

  void partition(int start, int end, TreeNode node) {
    if (start >= end - 1) {
      return;
    }

    double valueOffset = sums[start];
    double valueTarget = (node.value / 2) + valueOffset;
    int left = start + 1;
    int right = end - 1;

    while (left < right) {
      int mid = left + right >> 1;

      if (sums[mid] < valueTarget) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    if ((valueTarget - sums[left - 1] < (sums[left] - valueTarget) &&
        start + 1 < left)) {
      left--;
    }

    double valueLeft = sums[left] - valueOffset;
    double valueRight = node.value - valueLeft;

    TreeNode nodeLeft = TreeNode(valueLeft);
    TreeNode nodeRight = TreeNode(valueRight);

    node.left = nodeLeft;
    node.right = nodeRight;

    partition(start, left, nodeLeft);
    partition(left, end, nodeRight);
  }

  partition(0, n, root);

  return root;
}
