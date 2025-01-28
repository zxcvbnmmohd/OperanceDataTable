// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/models.dart';

/// The default width of a column.
const defaultWidth = OperanceDataColumnWidth();

/// A class representing a column in the OperanceDataTable.
class OperanceDataColumn<T> {
  /// Creates an instance of [OperanceDataColumn].
  ///
  /// Required parameters:
  ///   - [name]: The unique name of the column.
  ///   - [columnHeader]: The widget to display as the column header.
  ///   - [cellBuilder]: A function that builds the cell widget for a given
  ///     item.
  ///
  /// Optional parameters:
  ///   - [getSearchableValue]: A function that retrieves a searchable value for
  ///     a given item.
  ///   - [primary]: The primary column. The primary column is the column that
  ///     is going to be take in the width of the columns that are hidden.
  ///     Defaults to `false`.
  ///   - [numeric]: Indicates whether the column contains numeric values.
  ///     Defaults to `false`.
  ///   - [sortable]: Indicates whether the column is sortable.
  ///     Defaults to `false`.
  ///   - [width]: The width of the column.
  ///     Defaults to an instance of [OperanceDataColumnWidth].
  const OperanceDataColumn({
    required this.name,
    required this.columnHeader,
    required this.cellBuilder,
    this.getSearchableValue,
    this.primary = false,
    this.numeric = false,
    this.sortable = false,
    this.width = defaultWidth,
  });

  /// The unique name of the column.
  final String name;

  /// The widget to display as the column header.
  final Widget columnHeader;

  /// A function that builds the cell widget for a given item. The function
  /// takes the build context and the item of type [T] as parameters.
  final Widget Function(BuildContext, T) cellBuilder;

  /// An optional function that retrieves a searchable value for a given item.
  /// The function takes the item of type [T] as a parameter and returns a
  /// string.
  final String Function(T)? getSearchableValue;

  /// The primary column. The primary column is the column that is going to be
  /// take in the width of the columns that are hidden.
  final bool primary;

  /// Indicates whether the column contains numeric values.
  final bool numeric;

  /// Indicates whether the column is sortable.
  final bool sortable;

  /// The width of the column.
  final OperanceDataColumnWidth width;
}
