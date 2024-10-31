// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class HiddenColumnsNotifier extends ValueNotifier<Set<int>> {
  HiddenColumnsNotifier({
    Set<int> hiddeColumns = const {},
  }) : super(hiddeColumns);

  void toggle(int column) {
    if (value.contains(column)) {
      value.remove(column);
    } else {
      value.add(column);
    }

    return notifyListeners();
  }

  void hideMany(List<int> columns) {
    value.addAll(columns);

    return notifyListeners();
  }

  void showAllColumns() {
    value.clear();

    return notifyListeners();
  }
}
