// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_decoration.dart';

/// A widget that represents a row in the OperanceDataTable.
class OperanceDataRow<T> extends StatelessWidget {
  /// Creates an instance of [OperanceDataRow].
  ///
  /// The [columnOrder], [columns], [row], [index] and [tableWidth] parameters
  /// are required.
  /// The [onEnter], [onExit], [onExpanded], [expansionBuilder], [onChecked],
  /// [onRowPressed], [decoration], [isHovered], [isSelected], [isExpanded],
  /// [showExpansionIcon], and [showCheckbox] parameters are optional.
  const OperanceDataRow({
    required this.columnOrder,
    required this.columns,
    required this.row,
    required this.index,
    required this.tableWidth,
    this.onEnter,
    this.onExit,
    this.onExpanded,
    this.expansionBuilder,
    this.onChecked,
    this.onRowPressed,
    this.decoration = const OperanceDataDecoration(),
    this.isHovered = false,
    this.isSelected = false,
    this.isExpanded = false,
    this.showExpansionIcon = false,
    this.showCheckbox = false,
    super.key,
  })  : assert(
          !showExpansionIcon ||
              (onExpanded != null && expansionBuilder != null),
          'if showExpansionIcon is true then onExpanded and expansionBuilder '
          'must not be null',
        ),
        assert(
          !showCheckbox || onChecked != null,
          'if showCheckbox is true then onChecked must not be null',
        );

  /// The order of the columns.
  final List<int> columnOrder;

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

  /// Callback when the row is expanded.
  final void Function(int)? onExpanded;

  /// Builder for the expanded content of the row.
  final Widget Function(T)? expansionBuilder;

  /// Callback when the checkbox is checked or unchecked.
  final void Function(int, {bool? isSelected})? onChecked;

  /// Callback when the row is pressed.
  final void Function(T)? onRowPressed;

  /// The decoration settings for the data table.
  final OperanceDataDecoration decoration;

  /// Indicates whether the row is hovered.
  final bool isHovered;

  /// Indicates whether the row is selected.
  final bool isSelected;

  /// Indicates whether the row is expanded.
  final bool isExpanded;

  /// Indicates whether the expansion icon is shown.
  final bool showExpansionIcon;

  /// Indicates whether the checkbox is shown.
  final bool showCheckbox;
  @override
  Widget build(BuildContext context) {
    final colors = decoration.colors;
    final icons = decoration.icons;
    final sizes = decoration.sizes;
    final styles = decoration.styles;
    final ui = decoration.ui;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MouseRegion(
          cursor:
              onRowPressed != null ? ui.rowCursor : SystemMouseCursors.basic,
          onEnter: onEnter,
          onExit: onExit,
          child: GestureDetector(
            onTap: onRowPressed != null ? () => onRowPressed!(row) : null,
            child: AnimatedContainer(
              duration: Duration(
                milliseconds: ui.animationDuration,
              ),
              color: isSelected
                  ? colors.rowSelectedColor.withOpacity(0.3)
                  : (isHovered ? colors.rowHoverColor : colors.rowColor),
              child: Row(
                children: <Widget>[
                  if (showExpansionIcon)
                    MouseRegion(
                      cursor: ui.rowExpansionCursor,
                      child: GestureDetector(
                        onTap: () => onExpanded!.call(index),
                        child: SizedBox(
                          width: 50.0,
                          child: AnimatedSwitcher(
                            duration: Duration(
                              milliseconds: ui.animationDuration,
                            ),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: child.key == ValueKey('expanded')
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
                            child: Icon(
                              isExpanded
                                  ? icons.rowExpansionIconExpanded
                                  : icons.rowExpansionIconCollapsed,
                              key: ValueKey(
                                isExpanded ? 'expanded' : 'collapsed',
                              ),
                              color: colors.rowExpansionIconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (showCheckbox)
                    SizedBox(
                      width: 50.0,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          onChecked?.call(index, isSelected: value);
                        },
                      ),
                    ),
                  ...columnOrder.map((index) {
                    final column = columns[index];

                    return Container(
                      alignment: column.numeric
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      padding: styles.cellPadding,
                      width: column.width.value(tableWidth),
                      height: sizes.rowHeight,
                      child: column.cellBuilder(context, row),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: Duration(
            milliseconds: ui.animationDuration,
          ),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
                  padding: styles.rowExpandedContainerPadding,
                  child: expansionBuilder!.call(row),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
