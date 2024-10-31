// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ExpandedRowsNotifier extends ValueNotifier<Map<int, bool>> {
  ExpandedRowsNotifier({
    Map<int, bool> rows = const <int, bool>{},
  }) : super(rows);

  void toggle(int index) {
    value[index] = !(value[index] ?? false);

    return notifyListeners();
  }

  void expandMany(List<int> indexes) {
    for (final index in indexes) {
      value[index] = true;
    }

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
