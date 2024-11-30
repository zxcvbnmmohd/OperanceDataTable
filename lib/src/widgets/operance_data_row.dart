// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/extensions/build_context.dart';
import 'package:operance_datatable/src/models/models.dart';

/// A widget that represents a row in the OperanceDataTable.
class OperanceDataRow<T> extends StatelessWidget {
  /// Creates an instance of [OperanceDataRow].
  ///
  /// The [columns], [row], [index] and [tableWidth] parameters are required.
  /// The [onEnter], [onExit], [expansionBuilder], [onChecked], [onRowPressed],
  /// [expandable], and [selectable] parameters are optional.
  const OperanceDataRow({
    required this.columns,
    required this.row,
    required this.index,
    required this.tableWidth,
    this.onEnter,
    this.onExit,
    this.onChecked,
    this.onRowPressed,
    this.expansionBuilder,
    this.expandable = false,
    this.selectable = false,
    super.key,
  });

  /// The list of columns.
  final List<OperanceDataColumn<T>> columns;

  /// The row to be displayed in the row.
  final T row;

  /// The index of the row.
  final int index;

  /// The width of the table.
  final double tableWidth;

  /// Callback when the pointer enters the row.
  final PointerEnterEventListener? onEnter;

  /// Callback when the pointer exits the row.
  final PointerExitEventListener? onExit;

  /// Callback when the checkbox is checked or unchecked.
  final ValueChanged<Set<T>>? onChecked;

  /// Callback when the row is pressed.
  final void Function(T)? onRowPressed;

  /// Builder for the expanded content of the row.
  final Widget Function(BuildContext, T)? expansionBuilder;

  /// Indicates whether the expansion icon is shown.
  final bool expandable;

  /// Indicates whether the checkbox is shown.
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final columnOrderNotifier = controller.columnOrderNotifier;
    final hiddenColumnsNotifier = controller.hiddenColumnsNotifier;
    final expandedRowsNotifier = controller.expandedRowsNotifier;
    final selectedRowsNotifier = controller.selectedRowsNotifier;
    final colors = decoration.colors;
    final icons = decoration.icons;
    final sizes = decoration.sizes;
    final styles = decoration.styles;
    final ui = decoration.ui;
    final canPress = onRowPressed != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MouseRegion(
          cursor: canPress ? ui.rowCursor : SystemMouseCursors.basic,
          onEnter: canPress ? onEnter : null,
          onExit: canPress ? onExit : null,
          child: GestureDetector(
            onTap: canPress ? () => onRowPressed!(row) : null,
            child: ValueListenableBuilder<Set<T>>(
              valueListenable: selectedRowsNotifier,
              builder: (context, selectedRows, child) {
                return ValueListenableBuilder<int?>(
                  valueListenable: controller.hoveredRowNotifier,
                  builder: (context, hoveredRow, child) {
                    return AnimatedContainer(
                      duration: Duration(
                        milliseconds: ui.animationDuration,
                      ),
                      color: selectedRows.contains(row)
                          ? colors.rowSelectedColor.withOpacity(0.3)
                          : hoveredRow == index
                              ? colors.rowHoverColor
                              : colors.rowColor,
                      child: Row(
                        children: <Widget>[
                          if (expandable)
                            MouseRegion(
                              cursor: canPress
                                  ? ui.rowCursor
                                  : SystemMouseCursors.basic,
                              child: GestureDetector(
                                onTap: () => expandedRowsNotifier.toggle(index),
                                child: SizedBox(
                                  width: 50.0,
                                  child: AnimatedSwitcher(
                                    duration: Duration(
                                      milliseconds: ui.animationDuration,
                                    ),
                                    transitionBuilder: (child, animation) {
                                      return RotationTransition(
                                        turns: child.key ==
                                                ValueKey('expanded_$index')
                                            ? Tween<double>(
                                                begin: 0.5,
                                                end: 1.0,
                                              ).animate(animation)
                                            : Tween<double>(
                                                begin: 1.0,
                                                end: 0.5,
                                              ).animate(animation),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: ValueListenableBuilder(
                                      valueListenable: expandedRowsNotifier,
                                      builder: (context, expandedRows, child) {
                                        final isExpanded =
                                            expandedRows[index] ?? false;

                                        return Icon(
                                          isExpanded
                                              ? icons.rowExpansionIconExpanded
                                              : icons.rowExpansionIconCollapsed,
                                          key: ValueKey(
                                            isExpanded
                                                ? 'expanded_$index'
                                                : 'collapsed_$index',
                                          ),
                                          color: colors.rowExpansionIconColor,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (selectable)
                            SizedBox(
                              width: 50.0,
                              child: Checkbox(
                                value: selectedRows.contains(row),
                                onChanged: (value) {
                                  selectedRowsNotifier.toggle(row);
                                  onChecked?.call(selectedRowsNotifier.value);
                                },
                              ),
                            ),
                          ValueListenableBuilder<Set<String>>(
                            valueListenable: hiddenColumnsNotifier,
                            builder: (context, hiddenColumns, _) {
                              return ValueListenableBuilder<Set<int>>(
                                valueListenable: columnOrderNotifier,
                                builder: (context, columnOrder, _) {
                                  var totalHiddenWidth = 0.0;

                                  for (final index in columnOrder) {
                                    if (hiddenColumns.contains(
                                      columns[index].name,
                                    )) {
                                      totalHiddenWidth += columns[index]
                                          .width
                                          .value(tableWidth);
                                    }
                                  }

                                  return Row(
                                    children: <Widget>[
                                      for (final index in columnOrder)
                                        if (!hiddenColumns.contains(
                                          columns[index].name,
                                        ))
                                          Container(
                                            alignment: columns[index].numeric
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            padding: styles.cellPadding,
                                            width: columns[index].primary
                                                ? columns[index]
                                                        .width
                                                        .value(tableWidth) +
                                                    totalHiddenWidth
                                                : columns[index]
                                                    .width
                                                    .value(tableWidth),
                                            height: sizes.rowHeight,
                                            child: columns[index].cellBuilder(
                                              context,
                                              row,
                                            ),
                                          ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        AnimatedSize(
          duration: Duration(
            milliseconds: ui.animationDuration,
          ),
          curve: Curves.easeInOut,
          child: ValueListenableBuilder<Map<int, bool>>(
            valueListenable: expandedRowsNotifier,
            builder: (context, expandedRows, child) {
              return expandedRows[index] ?? false
                  ? Container(
                      padding: styles.rowExpandedContainerPadding,
                      child: expansionBuilder?.call(context, row),
                    )
                  : SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
