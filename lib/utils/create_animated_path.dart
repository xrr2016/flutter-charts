import 'dart:ui';

Path createAnimatedPath(
  Path path,
  double percent,
) {
  final totalLength = path
      .computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);
  final currentLength = totalLength * percent;

  return extractPathUntilLength(path, currentLength);
}

Path extractPathUntilLength(
  Path originalPath,
  double length,
) {
  final path = Path();
  var currentLength = 0.0;
  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;
    var nextLength = currentLength + metric.length;
    final isLastSegment = nextLength > length;

    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);
      path.addPath(pathSegment, Offset.zero);
      break;
    } else {
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}
