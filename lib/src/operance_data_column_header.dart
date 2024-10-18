// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/misc.dart';
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_decoration.dart';

/// A widget that represents the header of a data column in the Operance data
/// table.
class OperanceDataColumnHeader<T> extends StatelessWidget {
  /// Creates an instance of [OperanceDataColumnHeader].
  ///
  /// The [columnOrder], [columns] and [tableWidth] parameters are required.
  /// The [trailing], [onChecked], [onColumnDragged], [onSort], [sorts]
  /// [currentRows], [selectedRows], [decoration], [allowColumnReorder],
  /// [expandable], and [selectable] parameters are optional.
  const OperanceDataColumnHeader({
    required this.columnOrder,
    required this.columns,
    required this.tableWidth,
    this.trailing,
    this.onChecked,
    this.onColumnDragged,
    this.onSort,
    this.sorts = const {},
    this.currentRows = const [],
    this.selectedRows = const {},
    this.decoration = const OperanceDataDecoration(),
    this.allowColumnReorder = false,
    this.expandable = false,
    this.selectable = false,
    super.key,
  });

  /// The order of the columns.
  final List<int> columnOrder;

  /// The list of columns.
  final List<OperanceDataColumn<T>> columns;

  /// The width of the table.
  final double tableWidth;

  /// List of widgets to be displayed at the end of the last column.
  final List<Widget>? trailing;

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<bool?>? onChecked;

  /// Callback when a column is dragged.
  final void Function(int, int)? onColumnDragged;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// The current rows in the table.
  final List<T> currentRows;

  /// The selected rows in the table.
  final Set<T> selectedRows;

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// Whether column reordering is allowed.
  final bool allowColumnReorder;

  /// Whether the column is expandable.
  final bool expandable;

  /// Whether the column is selectable.
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final sizes = decoration.sizes;
    final styles = decoration.styles;

    return SizedBox(
      height: sizes.columnHeaderHeight,
      child: Row(
        children: <Widget>[
          if (expandable)
            Container(
              decoration: styles.columnHeaderDecoration,
              width: 50.0,
              height: sizes.columnHeaderHeight,
            ),
          if (selectable)
            Container(
              decoration: styles.columnHeaderDecoration,
              width: 50,
              height: sizes.columnHeaderHeight,
              child: Checkbox(
                value: selectedRows.isNotEmpty &&
                    selectedRows.length == currentRows.length,
                onChanged: onChecked,
              ),
            ),
          for (final index in columnOrder)
            Builder(
              builder: (context) {
                final column = columns[index];
                final columnWidth = column.width.value(tableWidth);

                return allowColumnReorder
                    ? _Draggable<T>(
                        column: column,
                        index: index,
                        tableWidth: tableWidth,
                        columnWidth: columnWidth,
                        decoration: decoration,
                        onColumnDragged: (details) {
                          final fromIndex = details.data;
                          final toIndex = index;

                          if (fromIndex != toIndex) {
                            final newOrder = List<int>.from(columnOrder);
                            final movedColumn = newOrder.removeAt(fromIndex);
                            newOrder.insert(toIndex, movedColumn);

                            onColumnDragged!(fromIndex, toIndex);
                          }
                        },
                        onSort: onSort,
                        sorts: sorts,
                      )
                    : _ColumnHeader<T>(
                        decoration: decoration,
                        column: column,
                        tableWidth: tableWidth,
                        columnWidth: columnWidth,
                        onSort: onSort,
                        sorts: sorts,
                        dragging: true,
                      );
              },
            ),
          if (trailing != null)
            ...trailing!.map((child) {
              return Container(
                decoration: styles.columnHeaderDecoration,
                width: 50.0,
                height: sizes.columnHeaderHeight,
                child: child,
              );
            })
        ],
      ),
    );
  }
}

/// A widget that represents a draggable column header in the OperanceDataTable.
class _Draggable<T> extends StatelessWidget {
  /// Creates an instance of [_Draggable].
  ///
  /// The [column] and [index] parameters are required.
  /// The [onColumnDragged], [onSort], [sorts], and [decoration] parameters are
  /// optional.
  const _Draggable({
    required this.column,
    required this.index,
    required this.tableWidth,
    required this.columnWidth,
    this.onColumnDragged,
    this.onSort,
    this.sorts = const {},
    this.decoration = const OperanceDataDecoration(),
  });

  /// The column to be displayed.
  final OperanceDataColumn<T> column;

  /// The index of the column.
  final int index;

  /// The width of the table.
  final double tableWidth;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// Callback when a column is dragged.
  final DragTargetAcceptWithDetails<int>? onColumnDragged;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        elevation: 5.0,
        child: _ColumnHeader(
          decoration: decoration,
          column: column,
          tableWidth: tableWidth,
          columnWidth: columnWidth,
        ),
      ),
      childWhenDragging: _ColumnHeader(
        decoration: decoration,
        column: column,
        tableWidth: tableWidth,
        columnWidth: columnWidth,
      ),
      child: DragTarget<int>(
        onAcceptWithDetails: onColumnDragged,
        builder: (context, _, __) {
          return _ColumnHeader(
            decoration: decoration,
            column: column,
            tableWidth: tableWidth,
            columnWidth: columnWidth,
            onSort: onSort,
            sorts: sorts,
            dragging: true,
          );
        },
      ),
    );
  }
}

/// A widget that represents a column header in the OperanceDataTable.
class _ColumnHeader<T> extends StatelessWidget {
  /// Creates an instance of [_ColumnHeader].
  ///
  /// The [decoration] and [column] parameters are required.
  /// The [onSort], [sorts], and [dragging] parameters are optional.
  const _ColumnHeader({
    required this.decoration,
    required this.column,
    required this.tableWidth,
    required this.columnWidth,
    this.onSort,
    this.sorts = const {},
    this.dragging = false,
    super.key,
  });

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// The column to be displayed.
  final OperanceDataColumn<T> column;

  /// The width of the table.
  final double tableWidth;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// Indicates whether the column is being dragged.
  final bool dragging;

  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final colors = decoration.colors;
    final icons = decoration.icons;
    final styles = decoration.styles;

    final sortIconBuilder = column.sortable
        ? Builder(
            builder: (context) {
              final columnName = column.name;
              final sortIndex = sorts.keys.toList().indexOf(columnName);
              final direction =
                  sortIndex != -1 ? sorts.values.toList()[sortIndex] : null;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onSort != null
                      ? () {
                          onSort!(
                            columnName,
                            sortIndex == -1
                                ? SortDirection.ascending
                                : direction == SortDirection.ascending
                                    ? SortDirection.descending
                                    : null,
                          );
                        }
                      : null,
                  child: Icon(
                    direction == SortDirection.ascending
                        ? icons.columnHeaderSortAscendingIcon
                        : icons.columnHeaderSortDescendingIcon,
                    color: sortIndex != -1
                        ? colors.columnHeaderSortIconEnabledColor
                        : colors.columnHeaderSortIconDisabledColor,
                    size: decoration.sizes.columnHeaderSortIconSize,
                  ),
                ),
              );
            },
          )
        : null;

    return RepaintBoundary(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: styles.columnHeaderDecoration.copyWith(
          color: dragging
              ? styles.columnHeaderDecoration.color
              : styles.columnHeaderDecoration.color!.withOpacity(0.5),
        ),
        width: columnWidth,
        height: decoration.sizes.columnHeaderHeight,
        child: Row(
          children: <Widget>[
            Expanded(child: column.columnHeader),
            if (sortIconBuilder != null) sortIconBuilder,
          ],
        ),
      ),
    );
  }
}
