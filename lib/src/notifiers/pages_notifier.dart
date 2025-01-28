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
    this.rowsPerPage = 25,
  }) : super(pages);

  /// The number of rows per page.
  int rowsPerPage;

  /// Returns all the rows across all pages.
  Set<T> get rows => value.expand((page) => page).toSet();

  /// Adds a row. The [row] is the row to add.
  set add(Set<T> rows) {
    value.add(rows.toSet());

    return notifyListeners();
  }

  /// Adds many rows. The [rows] are the rows to add.
  set addAll(Set<T> rows) {
    value
      ..clear()
      ..addAll(<Set<T>>[
        for (int i = 0; i < rows.length; i += rowsPerPage)
          rows.skip(i).take(rowsPerPage).toSet()
      ]);

    return notifyListeners();
  }

  /// Updates a row. The [oldItem] is the row to update. The [newItem] is the
  /// new row. The [oldItem] is removed and the [newItem] is added in its place
  /// in the same page in the same position.
  void updateRow(T oldItem, T newItem) {
    for (final page in value) {
      if (page.contains(oldItem)) {
        final items = page.toList();
        final index = items.indexOf(oldItem);

        items[index] = newItem;

        page
          ..clear()
          ..addAll(items);

        return notifyListeners();
      }
    }
  }

  /// Resets the pages. Clears all the rows.
  void reset() {
    value
      ..clear()
      ..add(<T>{});

    return notifyListeners();
  }
}
