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

  /// Returns a new eagerly computed [List] with elements of type [T], intertwined with the results of `f`.
  ///
  ///
  /// `intertwineMode`:
  ///  > BEFORE
  ///    : [a, b] => [f(0), a, f(1), b]
  ///  > AFTER
  ///    : [a, b] => [a, f(0), b, f(1)]
  ///  > SURROUND
  ///    : [a, b] => [f(0), a, f(1), b, f(2)]
  ///
  /// `ignoreNullFromF`: If `f` provides `null` the element is not followed/prepended with `null`
  ///
  /// ___________
  /// For example:
  ///
  /// ```
  /// List<String> l = ["a", "b", "c"];
  /// l.intertwine((int index) => index < l.length -1 ? "$index" : null, ignoreNullFromF: true);
  /// ```
  ///
  /// Returns `["a", "0", "b", "1", "c"]` // Note the missing index after "c"
  ///
  List<E> intertwine<E>(E f(int index),
      {IntertwineMode intertwineMode = IntertwineMode.AFTER, bool ignoreNullFromF = false}) {
    List<E> Function(int i) _intertwineElement;
    if (intertwineMode == IntertwineMode.AFTER) {
      if (ignoreNullFromF) {
        /// Evaluate f(i) and check result for null, if it is null do not include it
        _intertwineElement =
            (int i) => ((E fEval) => fEval == null ? [this.elementAt(i) as E] : [this.elementAt(i) as E, fEval])(f(i));
      } else {
        _intertwineElement = (int i) => [this.elementAt(i) as E, f(i)];
      }
    }
    // : Before or souround; souround will add one more at the end with i = length
    else {
      if (ignoreNullFromF) {
        /// Evaluate f(i) and check result for null, if it is null do not include it
        _intertwineElement =
            (int i) => ((E fEval) => fEval == null ? [this.elementAt(i) as E] : [fEval, this.elementAt(i) as E])(f(i));
      } else {
        _intertwineElement = (int i) => [f(i), this.elementAt(i) as E];
      }
    }

    List<E> r = [];
    for (int i = 0; i < this.length; i++) {
      r.addAll(
        _intertwineElement(i),
      );
    }
    if (intertwineMode == IntertwineMode.SURROUND) {
      E fEval = f(this.length);
      if (!(ignoreNullFromF && fEval == null)) {
        r.add(fEval);
      }
    }
    return r;
  }
}

enum IntertwineMode {
  BEFORE,
  AFTER,
  SURROUND,
}
