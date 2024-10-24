// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/operance_data_column_width.dart';

/// A class representing a column in the OperanceDataTable.
class OperanceDataColumn<T> {
  /// Creates an instance of [OperanceDataColumn].
  ///
  /// The [name], [columnHeader], [cellBuilder], and [getValue] parameters are
  /// required.
  /// The [getSearchableValue], [numeric], [sortable], [filterable], and [width]
  /// parameters are optional.
  const OperanceDataColumn({
    required this.name,
    required this.columnHeader,
    required this.cellBuilder,
    this.getSearchableValue,
    this.numeric = false,
    this.sortable = false,
    this.filterable = false,
    this.filterType,
    this.filterOptions = const [],
    this.width = const OperanceDataColumnWidth(),
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

  /// The type of filter to apply to the column.
  ///
  /// This could be an enum or a string representing the filter type.
  final String? filterType;

  /// The options available for filtering the column.
  ///
  /// This could be a list of values that the column can be filtered by.
  final List<dynamic> filterOptions;

  /// The width of the column.
  ///
  /// Defaults to an instance of [OperanceDataColumnWidth].
  final OperanceDataColumnWidth width;
}
