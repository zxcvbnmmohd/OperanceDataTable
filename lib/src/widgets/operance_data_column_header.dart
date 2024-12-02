// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/extensions/extensions.dart';
import 'package:operance_datatable/src/models/models.dart';
import 'package:operance_datatable/src/providers/providers.dart';
import 'package:operance_datatable/src/values/values.dart';

/// A widget that represents the header of a data column in the Operance data
/// table.
class OperanceDataColumnHeader<T> extends StatelessWidget {
  /// Creates an instance of [OperanceDataColumnHeader].
  ///
  /// The [columns] and [tableWidth] parameters are required.
  /// The [trailing], [onChecked], [decoration], [allowColumnReorder],
  /// [expandable], and [selectable] parameters are optional.
  const OperanceDataColumnHeader({
    required this.columns,
    required this.tableWidth,
    this.onChecked,
    this.trailing = const <Widget>[],
    this.allowColumnReorder = false,
    this.expandable = false,
    this.selectable = false,
    super.key,
  });

  /// The list of columns.
  final List<OperanceDataColumn<T>> columns;

  /// The width of the table.
  final double tableWidth;

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<Set<T>>? onChecked;

  /// List of widgets to be displayed at the end of the last column.
  final List<Widget> trailing;

  /// Whether column reordering is allowed.
  final bool allowColumnReorder;

  /// Whether the column is expandable.
  final bool expandable;

  /// Whether the column is selectable.
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
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
                child: _SelectableCheckbox<T>(
                  onChecked: onChecked,
                ),
              ),
            ValueListenableBuilder<Set<String>>(
              valueListenable: controller.hiddenColumnsNotifier,
              builder: (context, hiddenColumns, _) {
                return ValueListenableBuilder<Set<int>>(
                  valueListenable: controller.columnOrderNotifier,
                  builder: (context, columnOrder, child) {
                    var totalHiddenWidth = 0.0;

                    for (final index in columnOrder) {
                      if (hiddenColumns.contains(columns[index].name)) {
                        totalHiddenWidth += columns[index].width.value(
                              tableWidth,
                            );
                      }
                    }

                    return Row(
                      children: <Widget>[
                        for (final index in columnOrder)
                          if (!hiddenColumns.contains(columns[index].name))
                            _ColumnHeaderCell<T>(
                              key: ValueKey('column_$index'),
                              column: columns[index],
                              tableWidth: tableWidth,
                              columnWidth: columns[index].primary
                                  ? columns[index].width.value(tableWidth) +
                                      totalHiddenWidth
                                  : columns[index].width.value(tableWidth),
                              allowColumnReorder: allowColumnReorder,
                              onColumnDragged: (fromIndex) {
                                controller.reorderColumn(
                                  fromIndex: fromIndex,
                                  toIndex: index,
                                );
                              },
                              index: index,
                            ),
                      ],
                    );
                  },
                );
              },
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
class _SelectableCheckbox<T> extends StatelessWidget {
  /// Creates an instance of [_SelectableCheckbox].
  ///
  /// The [onChecked] parameter is required.
  const _SelectableCheckbox({
    required this.onChecked,
  });

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<Set<T>>? onChecked;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();

    return Container(
      decoration: context.decoration().styles.columnHeaderDecoration,
      child: ValueListenableBuilder(
        valueListenable: controller.selectedRowsNotifier,
        builder: (context, selectedRows, child) {
          final currentRows = controller.currentRows;

          return Checkbox(
            value: selectedRows.isNotEmpty &&
                selectedRows.length == currentRows.length,
            onChanged: (value) {
              if (value == null || value == false) {
                controller.resetSelectedRows();
              } else {
                controller.selectManyRows = currentRows.toSet();
              }

              onChecked?.call(selectedRows);
            },
          );
        },
      ),
    );
  }
}

/// A widget that represents a column header cell in the OperanceDataTable.
class _ColumnHeaderCell<T> extends StatelessWidget {
  /// Creates an instance of [_ColumnHeaderCell].
  ///
  /// The [column], [tableWidth], [allowColumnReorder], [onColumnDragged]
  /// and [index]
  /// parameters are required.
  /// The [columnWidth] parameter is optional.
  const _ColumnHeaderCell({
    required this.column,
    required this.tableWidth,
    required this.allowColumnReorder,
    required this.onColumnDragged,
    required this.index,
    this.columnWidth,
    super.key,
  });

  /// The column data.
  final OperanceDataColumn<T> column;

  /// The width of the table.
  final double tableWidth;

  /// The width of the column.
  final double? columnWidth;

  /// Whether column reordering is allowed.
  final bool allowColumnReorder;

  /// Callback when a column is dragged.
  final void Function(int)? onColumnDragged;

  /// The index of the column.
  final int index;

  @override
  Widget build(BuildContext context) {
    final headerContent = OperanceDataControllerProvider<T>(
      controller: context.controller<T>(),
      child: OperanceDataDecorationProvider(
        decoration: context.decoration(),
        child: _ColumnHeader<T>(
          key: ValueKey('header_${column.name}'),
          column: column,
          tableWidth: tableWidth,
          columnWidth: columnWidth ?? column.width.value(tableWidth),
        ),
      ),
    );

    return allowColumnReorder
        ? _Draggable(
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
class _Draggable extends StatelessWidget {
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
  /// The [column], [tableWidth] and [columnWidth] parameters are required.
  const _ColumnHeader({
    required this.column,
    required this.tableWidth,
    required this.columnWidth,
    super.key,
  });

  /// The column data.
  final OperanceDataColumn<T> column;

  /// The width of the table.
  final double tableWidth;

  /// The width of the column.
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final decoration = context.decoration();
    final sizes = decoration.sizes;
    final styles = decoration.styles;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: styles.columnHeaderDecoration,
      width: columnWidth,
      height: sizes.columnHeaderHeight,
      child: Row(
        children: <Widget>[
          Expanded(child: column.columnHeader),
          if (column.sortable)
            _SortIcon<T>(
              key: ValueKey('sort_${column.name}'),
              columnName: column.name,
            ),
        ],
      ),
    );
  }
}

/// A widget that represents the sort icon in a column header in the
/// OperanceDataTable.
class _SortIcon<T> extends StatelessWidget {
  /// Creates an instance of [_SortIcon].
  ///
  /// The [columnName] parameter is required.
  const _SortIcon({
    required this.columnName,
    super.key,
  });

  /// The name of the column.
  final String columnName;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final colors = decoration.colors;
    final icons = decoration.icons;
    final sizes = decoration.sizes;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ValueListenableBuilder<Map<String, SortDirection>>(
        valueListenable: controller.sortsNotifier,
        builder: (context, sorts, child) {
          final sortIndex = sorts.keys.toList().indexOf(columnName);
          final direction =
              sortIndex != -1 ? sorts.values.toList()[sortIndex] : null;

          return GestureDetector(
            onTap: () {
              controller.toggleSort(
                column: columnName,
                direction: sortIndex == -1
                    ? SortDirection.ascending
                    : direction == SortDirection.ascending
                        ? SortDirection.descending
                        : null,
              );
            },
            child: Icon(
              direction == SortDirection.ascending
                  ? icons.columnHeaderSortAscendingIcon
                  : icons.columnHeaderSortDescendingIcon,
              color: sortIndex != -1
                  ? colors.columnHeaderSortIconEnabledColor
                  : colors.columnHeaderSortIconDisabledColor,
              size: sizes.columnHeaderSortIconSize,
            ),
          );
        },
      ),
    );
  }
}
