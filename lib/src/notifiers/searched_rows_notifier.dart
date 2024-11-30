// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SearchedRowsNotifier<T> extends ValueNotifier<(Set<T>, bool)> {
  SearchedRowsNotifier({Set<T> rows = const {}}) : super((rows, false));

  void addRows(Set<T> rows) {
    value = (
      value.$1
        ..clear()
        ..addAll(rows),
      true,
    );

    return notifyListeners();
  }

  void clear() {
    value = (
      value.$1..clear(),
      false,
    );

    return notifyListeners();
  }
}
