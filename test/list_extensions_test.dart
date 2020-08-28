import 'package:flutter_test/flutter_test.dart';

import 'package:list_extensions/list_extensions.dart';

void main() {
  group("ForEachIndexed", () {
    test('copies list with manipulated elements', () {
      final List<String> l0 = ["a", "b", "c"];
      final List l1 = l0.forEachIndexed((index, e) => {index: e});

      expect(l1 == l0, false);
      expect(l1, [
        {0: "a"},
        {1: "b"},
        {2: "c"}
      ]);
    });
  });
}
