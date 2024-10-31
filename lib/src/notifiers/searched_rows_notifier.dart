// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SearchedRowsNotifier<T> extends ValueNotifier<Set<T>> {
  SearchedRowsNotifier({Set<T> rows = const {}}) : super(rows);

  void addRows(List<T> rows) {
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
