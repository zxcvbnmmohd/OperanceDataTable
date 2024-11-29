// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
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
  /// [loadingStateBuilder], [emptyStateBuilder], [expansionBuilder],
  /// [onRowPressed], [onSelectionChanged], [onCurrentPageIndexChanged],
  /// [decoration], [initialPage], [currentPageIndex], [header],
  /// [columnHeaderTrailingActions], [expandable], [selectable], [searchable],
  /// [showHeader], [showColumnHeader], [showFooter], [showEmptyRows],
  /// [showRowsPerPageOptions], [infiniteScroll] and [allowColumnReorder]
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
    this.expansionBuilder,
    this.onRowPressed,
    this.onSelectionChanged,
    this.onCurrentPageIndexChanged,
    this.decoration = const OperanceDataDecoration(),
    this.initialPage = (const [], false),
    this.currentPageIndex = 0,
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
    super.key,
  })  : assert(
          columns.isNotEmpty,
          "columns can't be empty",
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
  final ValueChanged<int>? onCurrentPageIndexChanged;

  /// Builder for the empty state of the table.
  final WidgetBuilder? emptyStateBuilder;

  /// Builder for the loading state of the table.
  final WidgetBuilder? loadingStateBuilder;

  /// Builder for the expanded content of a row.
  final Widget Function(T)? expansionBuilder;

  /// Callback when a row is pressed.
  final void Function(T)? onRowPressed;

  /// Callback when the selection changes.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Decoration settings for the table.
  final OperanceDataDecoration decoration;

  /// List of initial items to be displayed in the table.
  final PageData<T> initialPage;

  /// The current page index.
  final int currentPageIndex;

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
  late final ValueChanged<int>? _onCurrentPageIndexChanged;
  late final WidgetBuilder? _emptyStateBuilder;
  late final WidgetBuilder? _loadingStateBuilder;
  late final Widget Function(T)? _expansionBuilder;
  late final void Function(T)? _onRowPressed;
  late final ValueChanged<Set<T>>? _onSelectionChanged;
  late final OperanceDataDecoration _decoration;
  late final PageData<T> _initialPage;
  late final int _currentPageIndex;
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

  final _columnWidths = <double>[];

  @override
  void initState() {
    super.initState();

    _columns = widget.columns;
    _onFetch = widget.onFetch;
    _onSearchFieldChanged = widget.onSearchFieldChanged;
    _emptyStateBuilder = widget.emptyStateBuilder;
    _loadingStateBuilder = widget.loadingStateBuilder;
    _expansionBuilder = widget.expansionBuilder;
    _onRowPressed = widget.onRowPressed;
    _onSelectionChanged = widget.onSelectionChanged;
    _onCurrentPageIndexChanged = widget.onCurrentPageIndexChanged;
    _decoration = widget.decoration;
    _initialPage = widget.initialPage;
    _currentPageIndex = widget.currentPageIndex;
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

    _controller = widget.controller ??
        OperanceDataController<T>(
          columnOrder: List.generate(
            widget.columns.length,
            (index) => index,
          ).toSet(),
          initialPage: _initialPage,
          currentPageIndex: _currentPageIndex,
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
    final colors = _decoration.colors;
    final icons = _decoration.icons;
    final sizes = _decoration.sizes;
    final styles = _decoration.styles;
    final ui = _decoration.ui;
    final searchPosition = ui.searchPosition;

    return OperanceDataControllerProvider<T>(
      controller: _controller,
      child: OperanceDataDecorationProvider(
        decoration: _decoration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopPlatform =
                defaultTargetPlatform == TargetPlatform.macOS ||
                    defaultTargetPlatform == TargetPlatform.windows ||
                    defaultTargetPlatform == TargetPlatform.linux;
            final tableWidth = isDesktopPlatform
                ? constraints.maxWidth
                : constraints.maxWidth > constraints.maxHeight
                    ? constraints.maxWidth
                    : constraints.maxHeight;
            final availableWidth = tableWidth - _extrasWidth;
            final tableHeight = constraints.maxHeight;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // ------------------------------ Header ---------------------
                if (_showHeader)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.headerHorizontalPadding,
                    ),
                    decoration: styles.headerDecoration,
                    height: sizes.headerHeight,
                    child: Row(
                      children: <Widget>[
                        if (_searchable &&
                            searchPosition == SearchPosition.left)
                          OperanceDataSearchField(
                            decoration: _decoration,
                            controller: _searchFieldController,
                            focusNode: _searchFieldFocusNode,
                            onChanged: _onSearchFieldChanged,
                          ),
                        ..._header,
                        if (_searchable &&
                            searchPosition == SearchPosition.right) ...<Widget>[
                          const Spacer(),
                          OperanceDataSearchField(
                            decoration: _decoration,
                            controller: _searchFieldController,
                            focusNode: _searchFieldFocusNode,
                            onChanged: _onSearchFieldChanged,
                          ),
                        ],
                      ],
                    ),
                  ),
                // ------------------------------ Table ----------------------
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: ui.horizontalScrollPhysics,
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
                              onSort: _controller.setSort,
                              sorts: _controller.sorts,
                              decoration: _decoration,
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
                                  ValueListenableBuilder<Set<Set<T>>>(
                                    valueListenable: _controller.pagesNotifier,
                                    builder: (context, pages, _) {
                                      final index =
                                          _controller.currentPageIndex;
                                      final currentRows = Set<T>.unmodifiable(
                                        _infiniteScroll
                                            ? pages.expand((element) => element)
                                            : index >= pages.length
                                                ? const []
                                                : pages.elementAt(index),
                                      );

                                      if (!_controller.loadingNotifier.value &&
                                          currentRows.isEmpty &&
                                          _emptyStateBuilder != null) {
                                        return _emptyStateBuilder.call(context);
                                      }

                                      return ValueListenableBuilder<Set<T>>(
                                        valueListenable:
                                            _controller.searchedRowsNotifier,
                                        builder: (context, searchedRows, _) {
                                          final activeRows =
                                              searchedRows.isNotEmpty
                                                  ? searchedRows
                                                  : currentRows;

                                          if (activeRows.isEmpty) {
                                            return const SizedBox();
                                          }

                                          var itemCount = activeRows.length;
                                          final rowHeight = sizes.rowHeight;

                                          if (_showEmptyRows &&
                                              (itemCount <
                                                  tableHeight / rowHeight)) {
                                            final emptyRows =
                                                tableHeight / rowHeight -
                                                    itemCount;

                                            itemCount += emptyRows.toInt();
                                          }

                                          return KeyboardListener(
                                            focusNode: _keyboardFocusNode,
                                            onKeyEvent: (event) => _hoverRow(
                                              event: event,
                                              rows: activeRows,
                                            ),
                                            child: ListView.separated(
                                              controller:
                                                  _verticalScrollController,
                                              shrinkWrap: true,
                                              itemCount: itemCount,
                                              itemBuilder: (context, index) {
                                                if (index >=
                                                    activeRows.length) {
                                                  return Container(
                                                    height: sizes.rowHeight,
                                                    color: colors.rowColor,
                                                  );
                                                }

                                                final row =
                                                    activeRows.elementAt(index);

                                                return OperanceDataRow<T>(
                                                  key: ValueKey(row),
                                                  columns: _columns,
                                                  row: row,
                                                  index: index,
                                                  tableWidth: availableWidth,
                                                  onEnter: (_) {
                                                    _controller
                                                        .hoveredRowNotifier
                                                        .value = index;
                                                  },
                                                  onExit: (_) {
                                                    _controller
                                                        .hoveredRowNotifier
                                                        .value = null;
                                                  },
                                                  expansionBuilder:
                                                      _expansionBuilder,
                                                  onChecked:
                                                      _onSelectionChanged,
                                                  onRowPressed: _onRowPressed,
                                                  decoration: _decoration,
                                                  showExpansionIcon:
                                                      _expandable,
                                                  showCheckbox: _selectable,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                if (!ui.rowDividerEnabled) {
                                                  return const SizedBox();
                                                }

                                                return Divider(
                                                  height:
                                                      sizes.rowDividerHeight,
                                                  thickness:
                                                      sizes.rowDividerThickness,
                                                  color: colors.rowDividerColor,
                                                  indent:
                                                      sizes.rowDividerIndent,
                                                  endIndent:
                                                      sizes.rowDividerEndIndent,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        _controller.loadingNotifier,
                                    builder: (context, loading, _) {
                                      if (loading) {
                                        if (_loadingStateBuilder != null) {
                                          return _loadingStateBuilder
                                              .call(context);
                                        }

                                        return LinearProgressIndicator(
                                          backgroundColor:
                                              colors.loadingBackgroundColor,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            colors.loadingProgressColor,
                                          ),
                                          minHeight: sizes.loadingHeight,
                                          borderRadius:
                                              styles.loadingBorderRadius,
                                        );
                                      }

                                      return const SizedBox();
                                    },
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.footerHorizontalPadding,
                    ),
                    decoration: styles.footerDecoration,
                    height: sizes.footerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _showRowsPerPageOptions
                            ? Row(
                                children: <Widget>[
                                  Text(
                                    ui.rowsPerPageText,
                                    style: styles.rowsPerPageTextStyle,
                                  ),
                                  const SizedBox(width: 8.0),
                                  ValueListenableBuilder<int>(
                                      valueListenable:
                                          _controller.rowsPerPageNotifier,
                                      builder: (context, rowsPerPage, _) {
                                        return DropdownButton<int>(
                                          value: rowsPerPage,
                                          items: ui.rowsPerPageOptions.map(
                                            (value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              _controller.setRowsPerPage(value);
                                            }
                                          },
                                        );
                                      }),
                                ],
                              )
                            : const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(icons.previousPageIcon),
                              onPressed: _controller.canGoPrevious
                                  ? _controller.previousPage
                                  : null,
                              splashRadius: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            IconButton(
                              icon: Icon(icons.nextPageIcon),
                              onPressed: _controller.canGoNext ||
                                      _controller.canFetchNext
                                  ? _controller.nextPage
                                  : null,
                              splashRadius: 24.0,
                            ),
                          ],
                        ),
                      ],
                    ),
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
    final availableWidth = width - _extrasWidth;
    final totalColumnWidth = _columns.fold(0.0, (acc, column) {
      return acc + column.width.value(availableWidth);
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
    final searchedRowsNotifier = _controller.searchedRowsNotifier;
    final searchedRows = searchedRowsNotifier.value;
    final searchText = _searchFieldController.text;

    if (searchText.isEmpty) {
      searchedRowsNotifier.clear();
    } else {
      final allRows = _controller.pagesNotifier.allRows;

      final rows = allRows
          .where(
            (row) => _columns.any((column) {
              return column.getSearchableValue
                      ?.call(row)
                      .contains(searchText) ??
                  false;
            }),
          )
          .toList();

      if (rows.length == searchedRows.length &&
          rows.every(searchedRows.contains)) {
        return;
      }

      searchedRowsNotifier.addRows(
        allRows
            .where(
              (row) => _columns.any((column) {
                return column.getSearchableValue
                        ?.call(row)
                        .contains(searchText) ??
                    false;
              }),
            )
            .toList(),
      );
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

  /// Handles keyboard events to navigate and interact with the table rows.
  void _hoverRow({required KeyEvent event, required Set<T> rows}) {
    final expandedRowsNotifier = _controller.expandedRowsNotifier;
    final hoveredRowNotifier = _controller.hoveredRowNotifier;
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
          expandedRowsNotifier.toggle(currentHoveredIndex);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (currentHoveredIndex != null) {
          expandedRowsNotifier.toggle(currentHoveredIndex);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (currentHoveredIndex != null) {
          _onRowPressed?.call(rows.elementAt(currentHoveredIndex));
        }
      }
    }
  }
}
