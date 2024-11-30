// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class PagesNotifier<T> extends ValueNotifier<Set<Set<T>>> {
  PagesNotifier({
    Set<Set<T>> pages = const {{}},
    int rowsPerPage = 25,
  })  : _rowsPerPage = rowsPerPage,
        super(pages);

  int _rowsPerPage;

  Set<T> get rows => value.expand((page) => page).toSet();

  set rowsPerPage(int rowsPerPage) {
    _rowsPerPage = rowsPerPage;
  }

  void add(List<T> rows) {
    value.add(rows.toSet());

    return notifyListeners();
  }

  void addAll(List<T> rows) {
    value
      ..clear()
      ..addAll(<Set<T>>[
        for (int i = 0; i < rows.length; i += _rowsPerPage)
          rows.skip(i).take(_rowsPerPage).toSet()
      ]);

    return notifyListeners();
  }

  void updateRow(T row) {
    final pages = value.toList();
    final page = pages.firstWhere((page) => page.contains(row)).toList();
    final index = page.indexWhere((r) => r == row);

    page
      ..remove(row)
      ..insert(index, row);

    value = pages.toSet();

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
