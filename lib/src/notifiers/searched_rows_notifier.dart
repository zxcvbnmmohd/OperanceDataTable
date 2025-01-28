// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A 2-tuple of a set of rows and a boolean.
/// The first element is the set of rows.
/// The second element is the indicator if the rows are being searched.
typedef SearchResult<T> = (Set<T>, bool);

/// A notifier for managing the searched rows. The [T] is the type of the row.
class SearchedRowsNotifier<T> extends ValueNotifier<SearchResult<T>> {
  /// Creates an instance of [SearchedRowsNotifier].
  ///
  /// The [rows] is the set of rows. The default value is an empty set.
  /// The second element of the tuple is the indicator if the rows are being
  /// searched. The default value is `false`.
  SearchedRowsNotifier({Set<T> rows = const {}}) : super((rows, false));

  /// Adds a set of rows. The [rows] are the rows to add.
  /// The second element of the tuple is set to `true`.
  set addRows(Set<T> rows) {
    value = (
      <T>{...rows},
      true,
    );

    return notifyListeners();
  }

  /// Sets the second element of the tuple to `true`.
  void toggleSearchMode({bool searching = false}) {
    value = (value.$1, searching);

    return notifyListeners();
  }

  /// Clears the rows.
  /// The second element of the tuple is set to `false`.
  void reset() {
    value = (
      value.$1..clear(),
      false,
    );

    return notifyListeners();
  }
}
