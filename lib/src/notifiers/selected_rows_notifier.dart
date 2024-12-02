// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier class for managing the state and behavior of the selected rows.
class SelectedRowsNotifier<T> extends ValueNotifier<Set<T>> {
  /// Creates an instance of [SelectedRowsNotifier].
  ///
  /// The [rows] are the selected rows.
  SelectedRowsNotifier({Set<T> rows = const {}}) : super(rows);

  /// Toggles the selection of the row. The [row] is the row to toggle. If the
  /// row is already selected, it will be unselected. If the row is not
  /// selected, it will be selected.
  set toggle(T row) {
    if (value.contains(row)) {
      value.remove(row);
    } else {
      value.add(row);
    }

    return notifyListeners();
  }

  /// Selects many rows. The [rows] are the rows to select.
  set selectMany(Set<T> rows) {
    value
      ..clear()
      ..addAll(rows);

    return notifyListeners();
  }

  /// Unselect all rows.
  void reset() {
    value.clear();

    return notifyListeners();
  }
}
