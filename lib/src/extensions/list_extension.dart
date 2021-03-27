extension ListExtension<T> on List<T> {
  void replaceWhere(bool Function(T) test, T toReplace) => this[indexWhere(test)] = toReplace;
}
