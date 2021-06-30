extension ListSum<T> on List<T> {
  V sum<V extends num>(V Function(T item) f) {
    return fold(0 as V, (previousValue, item) => previousValue + f(item) as V);
  }
}

extension IterableSum<T> on Iterable<T> {
  V sum<V extends num>(V Function(T item) f) {
    return fold(0 as V, (previousValue, item) => previousValue + f(item) as V);
  }
}
