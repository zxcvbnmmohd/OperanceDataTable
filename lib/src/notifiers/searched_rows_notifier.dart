// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier for managing the searched rows. The [T] is the type of the row.
class SearchedRowsNotifier<T> extends ValueNotifier<(Set<T>, bool)> {
  /// Creates an instance of [SearchedRowsNotifier].
  ///
  /// The [rows] is the set of rows. The default value is an empty set.
  /// The [isSearching] is the indicator if the rows are being searched.
  /// The default value is `false`.
  SearchedRowsNotifier({Set<T> rows = const {}}) : super((rows, false));

  /// Adds a set of rows. The [rows] are the rows to add.
  /// The [isSearching] is set to `true`.
  set addRows(Set<T> rows) {
    value = (
      value.$1
        ..clear()
        ..addAll(rows),
      true,
    );

    return notifyListeners();
  }

  /// Clears the rows.
  /// The [isSearching] is set to `false`.
  void reset() {
    value = (
      value.$1..clear(),
      false,
    );

    return notifyListeners();
  }
}
