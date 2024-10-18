// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// 🌎 Project imports:
import 'package:operance_datatable/src/operance_data_column_width.dart';

/// A class representing a column in the OperanceDataTable.
class OperanceDataColumn<T extends Object> {
  /// Creates an instance of [OperanceDataColumn].
  ///
  /// The [name], [columnHeader], [cellBuilder], and [getValue] parameters are
  /// required.
  /// The [getSearchableValue], [numeric], [sortable], [filterable], and [width]
  /// parameters are optional with default values.
  OperanceDataColumn({
    required this.name,
    required this.columnHeader,
    required this.cellBuilder,
    this.getSearchableValue,
    this.numeric = false,
    this.sortable = false,
    this.filterable = false,
    this.width = const OperanceDataColumnWidth(),
    this.comparator,
    this.valueGetter,
    this.filterPredicate,
    this.includeInGlobalSearch,
  });

  /// The name of the column.
  final String name;

  /// The widget to display as the column header.
  final Widget columnHeader;

  /// A function that builds the cell widget for a given item.
  ///
  /// The function takes the build context and the item of type [T] as
  /// parameters.
  final Widget Function(BuildContext, T) cellBuilder;

  /// An optional function that retrieves a searchable value for a given item.
  ///
  /// The function takes the item of type [T] as a parameter and returns a
  /// string.
  final String Function(T)? getSearchableValue;

  /// Indicates whether the column contains numeric values.
  ///
  /// Defaults to `false`.
  final bool numeric;

  /// Indicates whether the column is sortable.
  ///
  /// Defaults to `false`.
  final bool sortable;

  /// Indicates whether the column is filterable.
  ///
  /// Defaults to `false`.
  final bool filterable;

  /// The width of the column.
  ///
  /// Defaults to an instance of [OperanceDataColumnWidth].
  final OperanceDataColumnWidth width;

  /// A custom comparator function for sorting.
  ///
  /// If provided, this function will be used for sorting instead of the default
  /// comparison. The function should return a negative value if a < b, zero if
  /// a == b, and a positive value if a > b.
  final int Function(T a, T b)? comparator;

  /// A function to extract the raw value from an item for sorting and
  /// filtering.
  ///
  /// This is more efficient than using [getSearchableValue] for large datasets.
  final dynamic Function(T item)? valueGetter;

  /// If provided, this function will be used to determine if an item
  /// matches the filter criteria.
  final bool Function(T item, dynamic filterValue)? filterPredicate;

  /// A function to determine if the column should be included in global searches.
  final bool Function(T item)? includeInGlobalSearch;

  /// Retrieves the value used for sorting.
  ///
  /// By default, uses [getSearchableValue] if available, otherwise falls back
  /// to `toString()`. Override this method for custom sorting behavior.
  String getSortValue(T item) =>
      getSearchableValue?.call(item) ?? item.toString();

  /// Retrieves the raw value used for sorting and filtering, with memoization.
  dynamic getRawValue(T item) {
    return _memoizedGetRawValue.putIfAbsent(
        item,
        () =>
            valueGetter?.call(item) ??
            getSearchableValue?.call(item) ??
            item.toString());
  }

  /// A memoized version of [getRawValue] for improved performance.
  final Map<T, dynamic> _memoizedGetRawValue = {};

  /// Determines if this column should be included in global searches for the given item.
  bool shouldIncludeInGlobalSearch(T item) =>
      includeInGlobalSearch?.call(item) ?? filterable;

  /// Clears the memoized values. Call this when the underlying data changes.
  void clearMemoizedValues() {
    _memoizedGetRawValue.clear();
  }

  /// Validates the column configuration.
  bool validate() {
    assert(sortable || comparator == null,
        'Comparator provided for non-sortable column');
    assert(filterable || filterPredicate == null,
        'Filter predicate provided for non-filterable column');
    // Add more validation as needed
    return true;
  }

  /// Creates a debug representation of the column.
  @override
  String toString() {
    if (kDebugMode) {
      return 'OperanceDataColumn(name: $name, sortable: $sortable, filterable: $filterable)';
    }
    return super.toString();
  }
}
