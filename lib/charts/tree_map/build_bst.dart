import './tree_node.dart';

TreeNode buildBST(List<double> list) {
  TreeNode _build(int start, int end) {
    if (start > end) {
      return null;
    }

    int mid = (start + end) >> 1;
    TreeNode root = TreeNode(list[mid]);

    root.left = _build(start, mid - 1);
    root.left = _build(mid + 1, end);

    return root;
  }

  return _build(0, list.length - 1);
}

void dfs(TreeNode root) {
  if (root == null) {
    return;
  }

  dfs(root.left);
  print(root.value);
  dfs(root.right);
}
