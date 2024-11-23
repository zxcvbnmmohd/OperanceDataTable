// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SelectedRowsNotifier<T> extends ValueNotifier<Set<T>> {
  SelectedRowsNotifier({Set<T> rows = const {}}) : super(rows);

  void toggle(T row) {
    if (value.contains(row)) {
      value.remove(row);
    } else {
      value.add(row);
    }

    return notifyListeners();
  }

  void selectAll(Set<T> rows) {
    value
      ..clear()
      ..addAll(rows);

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
