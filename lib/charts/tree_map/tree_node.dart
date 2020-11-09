class TreeNode {
  final double value;
  TreeNode left;
  TreeNode right;

  TreeNode(this.value);
}

void dfs(TreeNode root) {
  if (root == null) {
    return;
  }

  print(root.value);
  dfs(root.left);
  dfs(root.right);
}
