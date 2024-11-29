// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ColumnOrderNotifier extends ValueNotifier<Set<int>> {
  ColumnOrderNotifier({Set<int> columnOrder = const {}}) : super(columnOrder);

  void reorder({required int fromIndex, required int toIndex}) {
    final newOrder = value.toList();
    final column = newOrder.removeAt(fromIndex);

    newOrder.insert(toIndex, column);
    value = newOrder.toSet();

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
