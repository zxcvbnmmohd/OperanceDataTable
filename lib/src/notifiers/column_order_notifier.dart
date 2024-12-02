// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// A notifier for managing the order of the columns.
class ColumnOrderNotifier extends ValueNotifier<Set<int>> {
  /// Creates an instance of [ColumnOrderNotifier].
  ///
  /// The [columnOrder] is the order of the columns.
  /// For example, `{0, 1, 2}`.
  ColumnOrderNotifier({Set<int> columnOrder = const <int>{}})
      : _originalColumnOrder = columnOrder,
        super(columnOrder);

  final Set<int> _originalColumnOrder;

  /// Reorders the column. The [fromIndex] is the index of the column to reorder
  /// from. The [toIndex] is the index of the column to reorder to.
  void reorder({required int fromIndex, required int toIndex}) {
    final newOrder = value.toList();
    final column = newOrder.removeAt(fromIndex);

    newOrder.insert(toIndex, column);
    value = newOrder.toSet();

    return notifyListeners();
  }

  /// Resets the column order to the original order.
  void reset() {
    value = _originalColumnOrder;

    return notifyListeners();
  }
}
