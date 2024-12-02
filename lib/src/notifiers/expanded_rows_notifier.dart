// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier for managing the expanded rows.
class ExpandedRowsNotifier extends ValueNotifier<Set<int>> {
  /// Creates an instance of [ExpandedRowsNotifier].
  ///
  /// The [rows] are the indexes of the expanded rows. The default value is an
  /// empty set.
  /// For example, `{0, 1, 2}`.
  ExpandedRowsNotifier({Set<int> rows = const <int>{}}) : super(rows);

  /// Toggles the expansion of the row. The [index] is the index of the row to
  /// toggle. If the row is already expanded, it will be collapsed. If the row
  /// is not expanded, it will be expanded.
  set toggle(int index) {
    if (value.contains(index)) {
      value.remove(index);
    } else {
      value.add(index);
    }

    return notifyListeners();
  }

  /// Expands many rows. The [indexes] are the indexes of the rows to expand.
  set expandMany(List<int> indexes) {
    value.addAll(indexes);

    return notifyListeners();
  }

  /// Collapses all rows.
  void reset() {
    value.clear();

    return notifyListeners();
  }
}
