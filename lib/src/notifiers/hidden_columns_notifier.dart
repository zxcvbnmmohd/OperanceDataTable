// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier for managing the hidden columns.
class HiddenColumnsNotifier extends ValueNotifier<Set<String>> {
  /// Creates an instance of [HiddenColumnsNotifier].
  ///
  /// The [columns] are the hidden columns. The default value is an empty set.
  /// For example, `{'id'}`.
  HiddenColumnsNotifier({
    Set<String> columns = const <String>{},
  }) : super(columns);

  /// Toggles the visibility of the column. The [column] is the column to
  /// toggle. If the column is already hidden, it will be shown. If the column
  /// is not hidden, it will be hidden.
  set toggle(String column) {
    if (value.contains(column)) {
      value.remove(column);
    } else {
      value.add(column);
    }

    return notifyListeners();
  }

  /// Hides many columns. The [columns] are the columns to hide.
  set hideMany(Set<String> columns) {
    value.addAll(columns);

    return notifyListeners();
  }

  /// Clears the hidden columns. Makes all columns visible.
  void reset() {
    value.clear();

    return notifyListeners();
  }
}
