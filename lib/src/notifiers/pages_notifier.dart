// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier for managing the pages of rows. The [T] is the type of the row.
class PagesNotifier<T> extends ValueNotifier<Set<Set<T>>> {
  /// Creates an instance of [PagesNotifier].
  ///
  /// The [pages] is the set of pages. The default value is an empty set.
  /// The [rowsPerPage] is the number of rows per page. The default value is 25.
  PagesNotifier({
    Set<Set<T>> pages = const {{}},
    int rowsPerPage = 25,
  })  : _rowsPerPage = rowsPerPage,
        super(pages);

  int _rowsPerPage;

  /// Returns all the rows across all pages.
  Set<T> get rows => value.expand((page) => page).toSet();

  /// Sets the number of rows per page.
  set rowsPerPage(int rowsPerPage) {
    _rowsPerPage = rowsPerPage;
  }

  /// Adds a row. The [row] is the row to add.
  set add(List<T> rows) {
    value.add(rows.toSet());

    return notifyListeners();
  }

  /// Adds many rows. The [rows] are the rows to add.
  set addAll(List<T> rows) {
    value
      ..clear()
      ..addAll(<Set<T>>[
        for (int i = 0; i < rows.length; i += _rowsPerPage)
          rows.skip(i).take(_rowsPerPage).toSet()
      ]);

    return notifyListeners();
  }

  /// Updates a row. The [row] is the row to update.
  set updateRow(T row) {
    final pages = value.toList();
    final page = pages.firstWhere((page) => page.contains(row)).toList();
    final index = page.indexWhere((r) => r == row);

    page
      ..remove(row)
      ..insert(index, row);

    value = pages.toSet();

    return notifyListeners();
  }

  /// Resets the pages. Clears all the rows.
  void reset() {
    value
      ..clear()
      ..add(<T>{});

    return notifyListeners();
  }
}
