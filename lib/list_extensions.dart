library list_extensions;

extension ListExtensions<E> on Iterable<E> {
  /// Returns a new eagerly computed [List] with elements of type [T] that are created by
  /// calling `f` on each element of this `List` with elements of type [E] in order of increasing index.
  ///
  /// `f` exposes the index and the element at that index.
  ///
  /// ___________
  /// For example:
  ///
  /// ```
  /// ["a", "b", "c"].forEachIndexed((int index, String element) => {index: element});
  /// ```
  ///
  /// Returns `[{0: a}, {1: b}, {2: c}]`
  ///
  List<T> forEachIndexed<T>(T f(int index, E e)) {
    List<T> r = [];
    for (int i = 0; i < this.length; i++) {
      r.add(
        f(i, this.elementAt(i)),
      );
    }
    return r;
  }
}
