import 'dart:core';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) f) {
    var index = 0;
    return map((element) => f(element, index++));
  }
}
