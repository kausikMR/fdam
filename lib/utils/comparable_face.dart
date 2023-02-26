import 'dart:math';

class ComparableFace {
  final List data;

  const ComparableFace(this.data);


  factory ComparableFace.fromList(List list) {
    return ComparableFace(list);
  }

  factory ComparableFace.fromMap(Map map) {
    return ComparableFace([]); // TODO: NEED TO CHANGE THIS
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  bool compare(ComparableFace face, int minDist, double threshold) {
    final dist = _euclideanDist(face.data, data);
    return dist <= threshold && dist < minDist;
  }

  num _euclideanDist(List a, List b) {
    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      sum += pow((a[i] - b[i]), 2);
    }
    return pow(sum, 0.5);
  }

}
