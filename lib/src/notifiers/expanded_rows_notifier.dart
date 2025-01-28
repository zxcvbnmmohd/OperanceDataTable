// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier class for managing the state and behavior of the selected rows.
class ExpandedRowsNotifier<T> extends ValueNotifier<Set<T>> {
  /// Creates an instance of [ExpandedRowsNotifier].
  ///
  /// The [rows] are the expanded rows.
  ExpandedRowsNotifier({Set<T> rows = const {}}) : super(rows);

  /// Toggles the expanded or collapse of the row. The [row] is the row to
  /// toggle. If the row is already expanded, it will be collapsed.
  set toggle(T row) {
    if (value.contains(row)) {
      value.remove(row);
    } else {
      value.add(row);
    }

    return notifyListeners();
  }

  /// Expands many rows. The [rows] are the rows to expand.
  set expandMany(Set<T> rows) {
    value
      ..clear()
      ..addAll(rows);

    return notifyListeners();
  }

  /// Collapse all rows.
  void reset() {
    value.clear();

    return notifyListeners();
  }
}
