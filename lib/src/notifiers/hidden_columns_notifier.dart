// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class HiddenColumnsNotifier extends ValueNotifier<Set<String>> {
  HiddenColumnsNotifier({Set<String> columns = const {}}) : super(columns);

  void toggle(String column) {
    if (value.contains(column)) {
      value.remove(column);
    } else {
      value.add(column);
    }

    return notifyListeners();
  }

  void hideMany(Set<String> columns) {
    value.addAll(columns);

    return notifyListeners();
  }

  void showAllColumns() {
    value.clear();

    return notifyListeners();
  }
}
