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
    this.onChecked,
    this.onColumnDragged,
    this.onSort,
    this.sorts = const {},
    this.trailing = const [],
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

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<bool?>? onChecked;

  /// Callback when a column is dragged.
  final void Function(int, int)? onColumnDragged;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// List of widgets to be displayed at the end of the last column.
  final List<Widget> trailing;

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

    return RepaintBoundary(
      child: SizedBox(
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
              SizedBox(
                width: 50,
                height: sizes.columnHeaderHeight,
                child: _SelectableCheckbox(
                  decoration: decoration,
                  selectedRows: selectedRows,
                  currentRows: currentRows,
                  onChecked: onChecked,
                ),
              ),
            for (final index in columnOrder)
              _ColumnHeaderCell<T>(
                key: ValueKey('column_$index'),
                column: columns[index],
                tableWidth: tableWidth,
                decoration: decoration,
                onSort: onSort,
                sorts: sorts,
                allowColumnReorder: allowColumnReorder,
                onColumnDragged: onColumnDragged != null
                    ? (fromIndex) => onColumnDragged!(fromIndex, index)
                    : null,
                columnOrder: columnOrder,
                index: index,
              ),
            for (final child in trailing)
              Container(
                decoration: styles.columnHeaderDecoration,
                width: 50.0,
                height: sizes.columnHeaderHeight,
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}

/// A widget that represents a selectable checkbox in the OperanceDataTable.
class _SelectableCheckbox extends StatelessWidget {
  /// Creates an instance of [_SelectableCheckbox].
  ///
  /// The [decoration], [selectedRows], [currentRows], and [onChecked]
  /// parameters are required.
  const _SelectableCheckbox({
    required this.decoration,
    required this.selectedRows,
    required this.currentRows,
    required this.onChecked,
  });

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// The selected rows in the table.
  final Set<dynamic> selectedRows;

  /// The current rows in the table.
  final List<dynamic> currentRows;

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<bool?>? onChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration.styles.columnHeaderDecoration,
      child: Checkbox(
        value: selectedRows.isNotEmpty &&
            selectedRows.length == currentRows.length,
        onChanged: onChecked,
      ),
    );
  }
}

/// A widget that represents a column header cell in the OperanceDataTable.
class _ColumnHeaderCell<T> extends StatelessWidget {
  /// Creates an instance of [_ColumnHeaderCell].
  ///
  /// The [column], [tableWidth], [decoration], [onSort], [sorts],
  /// [allowColumnReorder], [onColumnDragged], [columnOrder], and [index]
  /// parameters are required.
  const _ColumnHeaderCell({
    required this.column,
    required this.tableWidth,
    required this.decoration,
    required this.onSort,
    required this.sorts,
    required this.allowColumnReorder,
    required this.onColumnDragged,
    required this.columnOrder,
    required this.index,
    super.key,
  });

  /// The column data.
  final OperanceDataColumn<T> column;

  /// The width of the table.
  final double tableWidth;

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// Whether column reordering is allowed.
  final bool allowColumnReorder;

  /// Callback when a column is dragged.
  final void Function(int)? onColumnDragged;

  /// The order of the columns.
  final List<int> columnOrder;

  /// The index of the column.
  final int index;

  @override
  Widget build(BuildContext context) {
    final columnWidth = column.width.value(tableWidth);
    final Widget headerContent = _ColumnHeader<T>(
      key: ValueKey('header_${column.name}'),
      decoration: decoration,
      column: column,
      tableWidth: tableWidth,
      columnWidth: columnWidth,
      onSort: onSort,
      sorts: sorts,
    );

    return allowColumnReorder
        ? _Draggable<T>(
            key: ValueKey('draggable_${column.name}'),
            columnName: column.name,
            index: index,
            onColumnDragged: onColumnDragged,
            child: headerContent,
          )
        : headerContent;
  }
}

/// A widget that represents a draggable column header cell in the
/// OperanceDataTable.
class _Draggable<T> extends StatelessWidget {
  /// Creates an instance of [_Draggable].
  ///
  /// The [child], [columnName], [index], and [onColumnDragged] parameters are
  /// required.
  const _Draggable({
    required this.child,
    required this.columnName,
    required this.index,
    required this.onColumnDragged,
    super.key,
  });

  /// The child widget to be displayed.
  final Widget child;

  /// The name of the column.
  final String columnName;

  /// The index of the column.
  final int index;

  /// Callback when a column is dragged.
  final void Function(int)? onColumnDragged;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        elevation: 5.0,
        child: child,
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: DragTarget<int>(
        onAcceptWithDetails: (details) => onColumnDragged?.call(details.data),
        builder: (context, _, __) => child,
      ),
    );
  }
}

/// A widget that represents the content of a column header in the
/// OperanceDataTable.
class _ColumnHeader<T> extends StatelessWidget {
  /// Creates an instance of [_ColumnHeader].
  ///
  /// The [decoration], [column], [tableWidth], [columnWidth], [onSort], and
  /// [sorts] parameters are required.
  const _ColumnHeader({
    required this.decoration,
    required this.column,
    required this.tableWidth,
    required this.columnWidth,
    required this.onSort,
    required this.sorts,
    super.key,
  });

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// The column data.
  final OperanceDataColumn<T> column;

  /// The width of the table.
  final double tableWidth;

  /// The width of the column.
  final double columnWidth;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  @override
  Widget build(BuildContext context) {
    final colors = decoration.colors;
    final icons = decoration.icons;
    final styles = decoration.styles;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: styles.columnHeaderDecoration,
      width: columnWidth,
      height: decoration.sizes.columnHeaderHeight,
      child: Row(
        children: <Widget>[
          Expanded(child: column.columnHeader),
          if (column.sortable && onSort != null)
            _SortIcon(
              columnName: column.name,
              sorts: sorts,
              onSort: onSort,
              icons: icons,
              colors: colors,
              size: decoration.sizes.columnHeaderSortIconSize,
            ),
        ],
      ),
    );
  }
}

/// A widget that represents the sort icon in a column header in the
/// OperanceDataTable.
class _SortIcon extends StatelessWidget {
  /// Creates an instance of [_SortIcon].
  ///
  /// The [columnName], [sorts], [onSort], [icons], [colors], and [size]
  /// parameters are required.
  const _SortIcon({
    required this.columnName,
    required this.sorts,
    required this.onSort,
    required this.icons,
    required this.colors,
    required this.size,
    super.key,
  });

  /// The name of the column.
  final String columnName;

  /// The current sort directions for the columns.
  final Map<String, SortDirection> sorts;

  /// Callback when a column is sorted.
  final void Function(String, SortDirection?)? onSort;

  /// The icons used in the data table.
  final OperanceDataIcons icons;

  /// The colors used in the data table.
  final OperanceDataColors colors;

  /// The size of the sort icon.
  final double size;

  @override
  Widget build(BuildContext context) {
    final sortIndex = sorts.keys.toList().indexOf(columnName);
    final direction = sortIndex != -1 ? sorts.values.toList()[sortIndex] : null;

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
          size: size,
        ),
      ),
    );
  }
}
