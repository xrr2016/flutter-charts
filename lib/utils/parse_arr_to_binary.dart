// eg:
//   List<int> input = [2, 10, 4, 3, 7, 5, 9, 8, 1, 6];
//   List<int> output = [0, 2, 12, 16, 19, 26, 31, 40, 48, 49,55];

List<double> parseArrToBinary(List<double> array) {
  // array.sort((a, b) => a.compareTo(b));

  array.insert(0, 0);
  List<double> result = array.sublist(0);

  for (int i = 1; i < array.length; i++) {
    result[i] = result[i - 1] + array[i];
  }

  return result;
}
