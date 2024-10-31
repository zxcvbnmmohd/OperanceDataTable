// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ColumnOrderNotifier extends ValueNotifier<Set<int>> {
  ColumnOrderNotifier({Set<int> columnOrder = const {}}) : super(columnOrder);

  void reorder(int oldIndex, int newIndex) {
    final newOrder = value.toList();
    final column = newOrder.removeAt(oldIndex);

    newOrder.insert(newIndex, column);
    value = newOrder.toSet();

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
