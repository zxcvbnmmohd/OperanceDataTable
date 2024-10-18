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
  }) : assert(
          (sortable && comparator != null) || !sortable,
          'Sortable columns must provide a comparator',
        );

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
  final bool numeric;

  /// Indicates whether the column is sortable.
  final bool sortable;

  /// Indicates whether the column is filterable.
  final bool filterable;

  /// The width of the column.
  final OperanceDataColumnWidth width;

  /// A custom comparator function for sorting.
  final int Function(T a, T b)? comparator;

  /// A function to extract the raw value from an item
  /// for sorting and filtering.
  final Object? Function(T item)? valueGetter;

  /// A function to determine if an item matches the filter criteria.
  final bool Function(T item, Object? filterValue)? filterPredicate;

  /// A function to determine if the column should
  /// be included in global searches.
  final bool Function(T item)? includeInGlobalSearch;

  /// Retrieves the value used for sorting.
  String getSortValue(T item) =>
      getSearchableValue?.call(item) ?? item.toString();

  /// Retrieves the raw value used for sorting and filtering, with memoization.
  Object? getRawValue(T item) => _memoizedGetRawValue.putIfAbsent(
        item,
        () =>
            valueGetter?.call(item) ??
            getSearchableValue?.call(item) ??
            item.toString(),
      );

  /// A memoized version of [getRawValue] for improved performance.
  final _memoizedGetRawValue = <T, Object?>{};

  /// Determines if this column should be included in global searches for the
  /// given item.
  bool shouldIncludeInGlobalSearch(T item) =>
      includeInGlobalSearch?.call(item) ?? filterable;

  /// Clears the memoized values. Call this when the underlying data changes.
  void clearMemoizedValues() => _memoizedGetRawValue.clear();

  /// Validates the column configuration.
  bool validate() {
    assert(
      !sortable || comparator != null,
      'Sortable columns must provide a comparator',
    );
    assert(
      !filterable || filterPredicate != null,
      'Filterable columns should provide a filter predicate '
      'for best performance',
    );
    return true;
  }

  @override
  String toString() => kDebugMode
      ? 'OperanceDataColumn(name: $name, sortable: $sortable, '
          'filterable: $filterable)'
      : super.toString();
}
