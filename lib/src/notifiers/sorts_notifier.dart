// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/values/values.dart';

/// A [ValueNotifier] that holds a map of column names and their sort
/// directions.
class SortsNotifier extends ValueNotifier<Map<String, SortDirection>> {
  /// Creates a [SortsNotifier] with an optional initial value.
  ///
  /// The [sorts] are the initial sort directions. The default value is an empty
  /// map. For example, `{'id': SortDirection.ascending}`.
  SortsNotifier({
    Map<String, SortDirection> sorts = const <String, SortDirection>{},
  }) : super(sorts);

  /// Toggles the sort direction of the column. The [column] is the column to
  /// toggle. If the column is already sorted, it will be unsorted. If the
  /// column is not sorted, it will be sorted in the [direction].
  void toggle({required String column, required SortDirection? direction}) {
    if (direction == null) {
      value.remove(column);
    } else {
      value[column] = direction;
    }

    return notifyListeners();
  }

  /// Clears the sort directions. Makes all columns unsorted.
  void reset() {
    value.clear();

    return notifyListeners();
  }
}
