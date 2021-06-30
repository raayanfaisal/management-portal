extension IterableIntersperse<T> on Iterable<T> {
  Iterable<T> intersperse(T item) => _intersperse(this, item);
}

extension ListIntersperse<T> on List<T> {
  List<T> intersperse(T item) => _intersperse(this, item).toList();
}

Iterable<T> _intersperse<T>(Iterable<T> iterable, T element) {
  if (iterable.length > 1) {
    return iterable.expand((e) => [e, element]).take((iterable.length * 2) - 1);
  }
  return iterable;
}
