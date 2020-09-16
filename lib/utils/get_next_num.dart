double getNextNum(double val) {
  double res;
  String a = '';

  while (val > 1) {
    val /= 10;
    a += '9';
  }

  double b = double.parse(a);
  double half = b / 2;

  if (val > half) {
    res = b;
  } else {
    res = half;
  }

  print(res);
  return res;
}
