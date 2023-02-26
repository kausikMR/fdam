extension EnumNameExtension on Enum {
  String get name => toString().split('.').last;
}

extension ListMapExtension on List {
  List<T> iterate<T>(T Function(dynamic) callback) {
    final List<T> list = [];
    for (final item in this) {
      list.add(callback(item));
    }
    return list;
  }
}
