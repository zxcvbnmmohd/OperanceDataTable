// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/extensions/build_context.dart';
import 'package:operance_datatable/src/models/models.dart';
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/providers/providers.dart';
import 'package:operance_datatable/src/values/values.dart';
import 'package:operance_datatable/src/widgets/widgets.dart';

/// The OperanceDataTable widget
class OperanceDataTable<T> extends StatefulWidget {
  /// Creates an instance of [OperanceDataTable].
  ///
  /// The [columns] parameter is required.
  /// The [onFetch], [controller], [keyboardFocusNode],
  /// [horizontalScrollController], [verticalScrollController],
  /// [searchFieldController], [searchFieldFocusNode], [onSearchFieldChanged],
  /// [loadingStateBuilder], [emptyStateBuilder], [emptySearchStateBuilder],
  /// [expansionBuilder], [onRowPressed], [onSelectionChanged],
  /// [onCurrentPageIndexChanged], [decoration], [initialPage], [currentPage],
  /// [header], [columnHeaderTrailingActions], [expandable], [selectable],
  /// [searchable], [showHeader], [showColumnHeader], [showFooter],
  /// [showEmptyRows], [showRowsPerPageOptions], [infiniteScroll] and
  /// [allowColumnReorder]
  /// parameters are optional.
  OperanceDataTable({
    required this.columns,
    this.onFetch,
    this.controller,
    this.keyboardFocusNode,
    this.horizontalScrollController,
    this.verticalScrollController,
    this.searchFieldController,
    this.searchFieldFocusNode,
    this.onSearchFieldChanged,
    this.loadingStateBuilder,
    this.emptyStateBuilder,
    this.emptySearchStateBuilder,
    this.expansionBuilder,
    this.onRowPressed,
    this.onSelectionChanged,
    this.onCurrentPageIndexChanged,
    this.decoration = const OperanceDataDecoration(),
    this.initialPage = (const [], false),
    this.currentPage = 0,
    this.header = const [],
    this.columnHeaderTrailingActions = const [],
    this.expandable = false,
    this.selectable = false,
    this.searchable = false,
    this.showHeader = false,
    this.showColumnHeader = true,
    this.showFooter = true,
    this.showEmptyRows = false,
    this.showRowsPerPageOptions = false,
    this.infiniteScroll = false,
    this.allowColumnReorder = false,
    this.allowColumnHiding = false,
    super.key,
  })  : assert(
          columns.isNotEmpty,
          "columns can't be empty",
        ),
        assert(
          columns.where((column) => column.primary).length == 1,
          'must provide 1 primary column',
        ),
        assert(
          decoration.ui.rowsPerPageOptions.isNotEmpty,
          'rowsPerPageOptions must contain at least 1 option',
        ),
        assert(
          !(searchable == true && showHeader == false),
          'showHeader must be true if searchable is true',
        ),
        assert(
          !(header.isNotEmpty && showHeader == false),
          'showHeader must be true if header is provided',
        );

  /// The list of columns to be displayed in the table.
  final List<OperanceDataColumn<T>> columns;

  /// Callback to fetch data for the table.
  final OnFetch<T>? onFetch;

  /// Controller to manage the state of the table.
  final OperanceDataController<T>? controller;

  /// Focus node for keyboard interactions.
  final FocusNode? keyboardFocusNode;

  /// Scroll controller for horizontal scrolling.
  final ScrollController? horizontalScrollController;

  /// Scroll controller for vertical scrolling.
  final ScrollController? verticalScrollController;

  /// Controller for the search field.
  final TextEditingController? searchFieldController;

  /// Focus node for the search field.
  final FocusNode? searchFieldFocusNode;

  /// Callback when the search field value changes.
  final ValueChanged<String?>? onSearchFieldChanged;

  /// Callback when the current page index changes.
  final OnCurrentPageIndexChanged? onCurrentPageIndexChanged;

  /// Builder for the empty state of the table.
  final WidgetBuilder? emptyStateBuilder;

  /// Builder for the empty search state of the table.
  final WidgetBuilder? emptySearchStateBuilder;

  /// Builder for the loading state of the table.
  final WidgetBuilder? loadingStateBuilder;

  /// Builder for the expanded content of a row.
  final Widget Function(BuildContext, T)? expansionBuilder;

  /// Callback when a row is pressed.
  final void Function(T)? onRowPressed;

  /// Callback when the selection changes.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Decoration settings for the table.
  final OperanceDataDecoration decoration;

  /// List of initial items to be displayed in the table.
  final PageData<T> initialPage;

  /// The current page index.
  final int currentPage;

  /// List of widgets to be displayed in the header.
  final List<Widget> header;

  /// List of widgets to be displayed at the end of the last column.
  final List<Widget> columnHeaderTrailingActions;

  /// Indicates whether the rows are expandable.
  final bool expandable;

  /// Indicates whether the rows are selectable.
  final bool selectable;

  /// Indicates whether the table is searchable.
  final bool searchable;

  /// Indicates whether the header is shown.
  final bool showHeader;

  /// Indicates whether the column header is shown.
  final bool showColumnHeader;

  /// Indicates whether the column header trailing actions are shown.
  final bool showFooter;

  /// Indicates whether empty rows are shown.
  final bool showEmptyRows;

  /// Indicates whether the rows per page options are shown.
  final bool showRowsPerPageOptions;

  /// Indicates whether infinite scroll is enabled.
  final bool infiniteScroll;

  /// Indicates whether column reordering is allowed.
  final bool allowColumnReorder;

  /// Indicates whether column hiding is allowed.
  final bool allowColumnHiding;

  @override
  OperanceDataTableState<T> createState() => OperanceDataTableState<T>();
}

class OperanceDataTableState<T> extends State<OperanceDataTable<T>> {
  static const _expansionWidth = 50.0;
  static const _selectionWidth = 50.0;

  late final List<OperanceDataColumn<T>> _columns;
  late final OnFetch<T>? _onFetch;
  late final OperanceDataController<T> _controller;
  late final FocusNode _keyboardFocusNode;
  late final ScrollController _horizontalScrollController;
  late final ScrollController _verticalScrollController;
  late final TextEditingController _searchFieldController;
  late final FocusNode _searchFieldFocusNode;
  late final ValueChanged<String?>? _onSearchFieldChanged;
  late final OnCurrentPageIndexChanged? _onCurrentPageIndexChanged;
  late final WidgetBuilder? _emptyStateBuilder;
  late final WidgetBuilder? _emptySearchStateBuilder;
  late final WidgetBuilder? _loadingStateBuilder;
  late final Widget Function(BuildContext, T)? _expansionBuilder;
  late final void Function(T)? _onRowPressed;
  late final ValueChanged<Set<T>>? _onSelectionChanged;
  late final OperanceDataDecoration _decoration;
  late final PageData<T> _initialPage;
  late final int _currentPage;
  late final List<Widget> _header;
  late final List<Widget> _columnHeaderTrailingActions;
  late final bool _expandable;
  late final bool _selectable;
  late final bool _searchable;
  late final bool _showHeader;
  late final bool _showColumnHeader;
  late final bool _showFooter;
  late final bool _showEmptyRows;
  late final bool _showRowsPerPageOptions;
  late final bool _infiniteScroll;
  late final bool _allowColumnReorder;
  late final bool _allowColumnHiding;

  final _columnWidths = <double>[];

  @override
  void initState() {
    super.initState();

    _columns = widget.columns;
    _onFetch = widget.onFetch;
    _onSearchFieldChanged = widget.onSearchFieldChanged;
    _emptyStateBuilder = widget.emptyStateBuilder;
    _emptySearchStateBuilder = widget.emptySearchStateBuilder;
    _loadingStateBuilder = widget.loadingStateBuilder;
    _expansionBuilder = widget.expansionBuilder;
    _onRowPressed = widget.onRowPressed;
    _onSelectionChanged = widget.onSelectionChanged;
    _onCurrentPageIndexChanged = widget.onCurrentPageIndexChanged;
    _decoration = widget.decoration;
    _initialPage = widget.initialPage;
    _currentPage = widget.currentPage;
    _header = widget.header;
    _columnHeaderTrailingActions = widget.columnHeaderTrailingActions;
    _expandable = widget.expandable;
    _selectable = widget.selectable;
    _searchable = widget.searchable;
    _showHeader = widget.showHeader;
    _showColumnHeader = widget.showColumnHeader;
    _showFooter = widget.showFooter;
    _showEmptyRows = widget.showEmptyRows;
    _showRowsPerPageOptions = widget.showRowsPerPageOptions;
    _infiniteScroll = widget.infiniteScroll;
    _allowColumnReorder = widget.allowColumnReorder;
    _allowColumnHiding = widget.allowColumnHiding;

    _controller = widget.controller ??
        OperanceDataController<T>(
          columnOrder: List.generate(
            widget.columns.length,
            (index) => index,
          ).toSet(),
          initialPage: _initialPage,
          currentPage: _currentPage,
          onCurrentPageIndexChanged: _onCurrentPageIndexChanged,
          rowsPerPage: _decoration.ui.rowsPerPageOptions.first,
          onFetch: _onFetch,
        );
    _keyboardFocusNode = (widget.keyboardFocusNode ?? FocusNode())
      ..requestFocus();
    _horizontalScrollController =
        widget.horizontalScrollController ?? ScrollController();
    _verticalScrollController = (widget.verticalScrollController ??
        ScrollController())
      ..addListener(_verticalScrollListener);
    _searchFieldController = (widget.searchFieldController ??
        TextEditingController())
      ..addListener(_searchFieldListener);
    _searchFieldFocusNode = widget.searchFieldFocusNode ?? FocusNode();

    _columnWidths.addAll(List.filled(widget.columns.length, 100));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    if (widget.keyboardFocusNode == null) {
      _keyboardFocusNode.dispose();
    }

    if (widget.horizontalScrollController == null) {
      _horizontalScrollController.dispose();
    }

    if (widget.verticalScrollController == null) {
      _verticalScrollController.dispose();
    } else {
      _verticalScrollController.removeListener(_verticalScrollListener);
    }

    if (widget.searchFieldController == null) {
      _searchFieldController.dispose();
    } else {
      _searchFieldController.removeListener(_searchFieldListener);
    }

    if (widget.searchFieldFocusNode == null) {
      _searchFieldFocusNode.dispose();
    }

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OperanceDataControllerProvider<T>(
      controller: _controller,
      child: OperanceDataDecorationProvider(
        decoration: _decoration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopPlatform = <TargetPlatform>[
              TargetPlatform.macOS,
              TargetPlatform.windows,
              TargetPlatform.linux,
            ].contains(defaultTargetPlatform);

            final tableWidth = isDesktopPlatform
                ? constraints.maxWidth
                : constraints.maxWidth > constraints.maxHeight
                    ? constraints.maxWidth
                    : constraints.maxHeight;
            final availableWidth = tableWidth - _extrasWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // ------------------------------ Header ---------------------
                if (_showHeader)
                  _OperanceDataTableHeader(
                    columns: _columns,
                    searchFieldController: _searchFieldController,
                    searchFieldFocusNode: _searchFieldFocusNode,
                    onSearchFieldChanged: _onSearchFieldChanged,
                    header: _header,
                    searchable: _searchable,
                    allowColumnHiding: _allowColumnHiding,
                  ),
                // ------------------------------ Table ----------------------
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: _decoration.ui.horizontalScrollPhysics,
                    controller: _horizontalScrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _tableMaxWidth(tableWidth),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (_showColumnHeader)
                            OperanceDataColumnHeader<T>(
                              columns: _columns,
                              tableWidth: availableWidth,
                              trailing: _columnHeaderTrailingActions,
                              onChecked: _onSelectionChanged,
                              allowColumnReorder: _allowColumnReorder,
                              expandable: _expandable,
                              selectable: _selectable,
                            ),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  _OperanceDataTableContent<T>(
                                    columns: _columns,
                                    availableWidth: availableWidth,
                                    keyboardFocusNode: _keyboardFocusNode,
                                    verticalScrollController:
                                        _verticalScrollController,
                                    searchFieldController:
                                        _searchFieldController,
                                    emptyStateBuilder: _emptyStateBuilder,
                                    emptySearchStateBuilder:
                                        _emptySearchStateBuilder,
                                    expansionBuilder: _expansionBuilder,
                                    onRowPressed: _onRowPressed,
                                    onSelectionChanged: _onSelectionChanged,
                                    expandable: _expandable,
                                    selectable: _selectable,
                                    showEmptyRows: _showEmptyRows,
                                    infiniteScroll: _infiniteScroll,
                                  ),
                                  _OperanceDataTableLoadingIndicator<T>(
                                    loadingStateBuilder: _loadingStateBuilder,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ------------------------------ Footer ---------------------
                if (_showFooter && !_infiniteScroll)
                  _OperanceDataTableFooter<T>(
                    showRowsPerPageOptions: _showRowsPerPageOptions,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Calculates the maximum available width of the table.
  double _tableMaxWidth(double width) {
    final totalColumnWidth = _columns.fold(0.0, (acc, column) {
      return acc + column.width.value(width - _extrasWidth);
    });

    return totalColumnWidth + _extrasWidth;
  }

  /// Calculates the width of the extras in the table.
  double get _extrasWidth {
    return (_expandable ? _expansionWidth : 0.0) +
        (_selectable ? _selectionWidth : 0.0) +
        (_columnHeaderTrailingActions.length * 50.0);
  }

  /// Listener for the search field to update the searched rows.
  void _searchFieldListener() {
    final searchText = _searchFieldController.text;

    if (searchText.isEmpty) {
      _controller.resetSearchedRows();
    } else {
      final rows = _controller.rows
          .where(
            (row) => _columns.any((column) {
              return column.getSearchableValue
                      ?.call(row)
                      .contains(searchText) ??
                  false;
            }),
          )
          .toList();

      final searchedRows = _controller.searchedRows;

      if (rows.length == searchedRows.length &&
          rows.every(searchedRows.contains)) {
        return;
      }

      _controller.addSearchedRows = rows
          .where((row) => _columns.any((column) {
                return column.getSearchableValue
                        ?.call(row)
                        .contains(searchText) ??
                    false;
              }))
          .toSet();
    }
  }

  /// Listener for the vertical scroll to fetch the next page if needed.
  void _verticalScrollListener() {
    if (_infiniteScroll &&
        _verticalScrollController.position.pixels ==
            _verticalScrollController.position.maxScrollExtent) {
      _controller.nextPage();
    }
  }
}

/// The OperanceDataColumnHeader widget
class _OperanceDataTableHeader<T> extends StatelessWidget {
  const _OperanceDataTableHeader({
    required this.columns,
    this.searchFieldController,
    this.searchFieldFocusNode,
    this.onSearchFieldChanged,
    this.header = const <Widget>[],
    this.searchable = false,
    this.allowColumnHiding = false,
  });

  /// The list of columns to be displayed in the table.
  final List<OperanceDataColumn<T>> columns;
  final TextEditingController? searchFieldController;
  final FocusNode? searchFieldFocusNode;
  final ValueChanged<String?>? onSearchFieldChanged;
  final List<Widget> header;
  final bool searchable;
  final bool allowColumnHiding;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final icons = decoration.icons;
    final sizes = decoration.sizes;
    final styles = decoration.styles;
    final searchPosition = decoration.ui.searchPosition;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.headerHorizontalPadding,
      ),
      decoration: styles.headerDecoration,
      height: sizes.headerHeight,
      child: Row(
        children: <Widget>[
          if (searchable && searchPosition == SearchPosition.left) ...<Widget>[
            OperanceDataSearchField(
              controller: searchFieldController,
              focusNode: searchFieldFocusNode,
              onChanged: onSearchFieldChanged,
            ),
            const SizedBox(width: 8.0),
            if (header.isEmpty) const Spacer(),
          ],
          ...header,
          if (header.isNotEmpty && searchable) const Spacer(),
          if (searchable && searchPosition == SearchPosition.right) ...<Widget>[
            if (header.isNotEmpty) const Spacer(),
            const SizedBox(width: 8.0),
            OperanceDataSearchField(
              controller: searchFieldController,
              focusNode: searchFieldFocusNode,
              onChanged: onSearchFieldChanged,
            ),
          ],
          if (allowColumnHiding) ...<Widget>[
            const SizedBox(width: 8.0),
            SizedBox(
              width: sizes.hiddenColumnsDropdownWidth,
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: controller.hiddenColumnsNotifier,
                builder: (context, hiddenColumns, _) {
                  final decoration = styles.hiddenColumnsDropdownDecoration;
                  final nonPrimaryColumns = columns.where((column) {
                    return !column.primary;
                  }).toList();

                  return DropdownButtonFormField<String>(
                    decoration: decoration.copyWith(
                      suffixIcon: hiddenColumns.isNotEmpty
                          ? IconButton(
                              icon: Icon(icons.hiddenColumnsDropdownClearIcon),
                              onPressed: controller.resetHiddenColumns,
                            )
                          : null,
                    ),
                    items: List<DropdownMenuItem<String>>.generate(
                      nonPrimaryColumns.length,
                      (index) {
                        final name = nonPrimaryColumns[index].name;

                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: !hiddenColumns.contains(name),
                                onChanged: (value) {},
                              ),
                              nonPrimaryColumns[index].columnHeader,
                            ],
                          ),
                        );
                      },
                    ),
                    selectedItemBuilder: (context) {
                      return nonPrimaryColumns.map((_) {
                        return decoration.label ?? Text(decoration.labelText!);
                      }).toList();
                    },
                    onChanged: (index) {
                      if (index != null) {
                        controller.toggleHideColumn = index;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OperanceDataTableContent<T> extends StatelessWidget {
  const _OperanceDataTableContent({
    required this.columns,
    required this.availableWidth,
    required this.keyboardFocusNode,
    this.verticalScrollController,
    this.searchFieldController,
    this.emptyStateBuilder,
    this.emptySearchStateBuilder,
    this.expansionBuilder,
    this.onRowPressed,
    this.onSelectionChanged,
    this.expandable = false,
    this.selectable = false,
    this.showEmptyRows = false,
    this.infiniteScroll = false,
  });

  final List<OperanceDataColumn<T>> columns;
  final double availableWidth;
  final FocusNode keyboardFocusNode;
  final ScrollController? verticalScrollController;
  final TextEditingController? searchFieldController;
  final WidgetBuilder? emptyStateBuilder;
  final WidgetBuilder? emptySearchStateBuilder;
  final Widget Function(BuildContext, T)? expansionBuilder;
  final void Function(T)? onRowPressed;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final bool expandable;
  final bool selectable;
  final bool infiniteScroll;
  final bool showEmptyRows;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final colors = decoration.colors;
    final sizes = decoration.sizes;
    final ui = decoration.ui;
    final rowHeight = sizes.rowHeight;

    return ValueListenableBuilder<int>(
      valueListenable: controller.currentPageNotifier,
      builder: (context, currentPage, _) {
        return ValueListenableBuilder<Set<Set<T>>>(
          valueListenable: controller.pagesNotifier,
          builder: (context, pages, _) {
            final currentRows = Set<T>.unmodifiable(
              infiniteScroll
                  ? pages.expand((element) => element)
                  : currentPage >= pages.length
                      ? const []
                      : pages.elementAt(currentPage),
            );

            if (!controller.loadingNotifier.value &&
                currentRows.isEmpty &&
                emptyStateBuilder != null) {
              return emptyStateBuilder!.call(context);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final tableHeight = constraints.maxHeight;

                return ValueListenableBuilder<(Set<T>, bool)>(
                  valueListenable: controller.searchedRowsNotifier,
                  builder: (context, searchedRows, _) {
                    final activeRows =
                        searchedRows.$2 ? searchedRows.$1 : currentRows;

                    if (activeRows.isEmpty) {
                      final builder = searchedRows.$2
                          ? emptySearchStateBuilder
                          : emptyStateBuilder;

                      return builder?.call(context) ?? const SizedBox();
                    }

                    var itemCount = activeRows.length;

                    if (showEmptyRows &&
                        (itemCount < tableHeight / rowHeight)) {
                      final emptyRows = tableHeight / rowHeight - itemCount;

                      itemCount += emptyRows.ceil();
                    }

                    return KeyboardListener(
                      focusNode: keyboardFocusNode,
                      onKeyEvent: (event) => _hoverRow(
                        context: context,
                        event: event,
                        rows: activeRows,
                      ),
                      child: ListView.separated(
                        controller: verticalScrollController,
                        shrinkWrap: true,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (index >= activeRows.length) {
                            return Container(
                              height: sizes.rowHeight,
                              color: colors.rowColor,
                            );
                          }

                          final row = activeRows.elementAt(index);

                          return OperanceDataRow<T>(
                            key: ValueKey(row),
                            columns: columns,
                            row: row,
                            index: index,
                            tableWidth: availableWidth,
                            onEnter: (_) {
                              controller.hoveredRowNotifier.value = index;
                            },
                            onExit: (_) {
                              controller.hoveredRowNotifier.value = null;
                            },
                            expansionBuilder: expansionBuilder,
                            onChecked: onSelectionChanged,
                            onRowPressed: onRowPressed,
                            expandable: expandable,
                            selectable: selectable,
                          );
                        },
                        separatorBuilder: (context, index) {
                          if (!ui.rowDividerEnabled) {
                            return const SizedBox();
                          }

                          return Divider(
                            height: sizes.rowDividerHeight,
                            thickness: sizes.rowDividerThickness,
                            color: colors.rowDividerColor,
                            indent: sizes.rowDividerIndent,
                            endIndent: sizes.rowDividerEndIndent,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Handles keyboard events to navigate and interact with the table rows.
  void _hoverRow({
    required BuildContext context,
    required KeyEvent event,
    required Set<T> rows,
  }) {
    final controller = context.controller<T>();
    final hoveredRowNotifier = controller.hoveredRowNotifier;
    final currentHoveredIndex = hoveredRowNotifier.value;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (currentHoveredIndex == null) {
          hoveredRowNotifier.value = 0;
        } else if (currentHoveredIndex < rows.length - 1) {
          hoveredRowNotifier.value = currentHoveredIndex + 1;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (currentHoveredIndex == null) {
          hoveredRowNotifier.value = 0;
        } else if (currentHoveredIndex > 0) {
          hoveredRowNotifier.value = currentHoveredIndex - 1;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (currentHoveredIndex != null) {
          controller.toggleExpandRow = currentHoveredIndex;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (currentHoveredIndex != null) {
          controller.toggleExpandRow = currentHoveredIndex;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (currentHoveredIndex != null) {
          onRowPressed?.call(rows.elementAt(currentHoveredIndex));
        }
      }
    }
  }
}

class _OperanceDataTableLoadingIndicator<T> extends StatelessWidget {
  const _OperanceDataTableLoadingIndicator({
    required this.loadingStateBuilder,
  });

  final WidgetBuilder? loadingStateBuilder;

  @override
  Widget build(BuildContext context) {
    final decoration = context.decoration();
    final colors = decoration.colors;
    final sizes = decoration.sizes;
    final styles = decoration.styles;

    return ValueListenableBuilder<bool>(
      valueListenable: context.controller<T>().loadingNotifier,
      builder: (context, loading, _) {
        if (!loading) {
          return const SizedBox();
        }

        if (loadingStateBuilder != null) {
          return loadingStateBuilder!.call(context);
        }

        return LinearProgressIndicator(
          backgroundColor: colors.loadingBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            colors.loadingProgressColor,
          ),
          minHeight: sizes.loadingHeight,
          borderRadius: styles.loadingBorderRadius,
        );
      },
    );
  }
}

class _OperanceDataTableFooter<T> extends StatelessWidget {
  const _OperanceDataTableFooter({
    this.showRowsPerPageOptions = false,
    super.key,
  });

  final bool showRowsPerPageOptions;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final sizes = decoration.sizes;
    final styles = decoration.styles;
    final icons = decoration.icons;
    final ui = decoration.ui;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: sizes.footerHorizontalPadding),
      decoration: styles.footerDecoration,
      height: sizes.footerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (showRowsPerPageOptions)
            Row(
              children: <Widget>[
                Text(
                  ui.rowsPerPageText,
                  style: styles.rowsPerPageTextStyle,
                ),
                const SizedBox(width: 8.0),
                ValueListenableBuilder<int>(
                  valueListenable: controller.rowsPerPageNotifier,
                  builder: (context, rowsPerPage, _) {
                    return DropdownButton<int>(
                      value: rowsPerPage,
                      items: ui.rowsPerPageOptions.map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setRowsPerPage = value;
                        }
                      },
                    );
                  },
                ),
              ],
            )
          else
            const Spacer(),
          ValueListenableBuilder<(bool, bool)>(
            valueListenable: controller.paginateNotifier,
            builder: (context, paginate, _) {
              const dimension = 24.0;

              return RepaintBoundary(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(icons.previousPageIcon),
                      onPressed: paginate.$1 ? controller.previousPage : null,
                      splashRadius: dimension,
                    ),
                    const SizedBox(width: 12.0),
                    ValueListenableBuilder<bool>(
                        valueListenable: controller.loadingNotifier,
                        builder: (context, loading, _) {
                          final nextEnabled = !loading && paginate.$2;

                          return IconButton(
                            icon: loading
                                ? SizedBox.square(
                                    dimension: dimension,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Icon(icons.nextPageIcon),
                            onPressed: nextEnabled ? controller.nextPage : null,
                            splashRadius: dimension,
                          );
                        }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
