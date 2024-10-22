// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/misc.dart';
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_column_header.dart';
import 'package:operance_datatable/src/operance_data_controller.dart';
import 'package:operance_datatable/src/operance_data_decoration.dart';
import 'package:operance_datatable/src/operance_data_row.dart';

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
  final ValueChanged<List<T>>? onSelectionChanged;

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
  late final ValueChanged<List<T>>? _onSelectionChanged;
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

    _controller = (widget.controller ?? OperanceDataController<T>())
      ..initialize(
        columnOrder: List.generate(widget.columns.length, (index) => index),
        initialPage: _initialPage,
        currentPageIndex: _currentPageIndex,
        onCurrentPageIndexChanged: _onCurrentPageIndexChanged,
        rowsPerPage: _decoration.ui.rowsPerPageOptions.first,
        infiniteScroll: _infiniteScroll,
        onFetch: _onFetch,
      )
      ..addListener(_controllerListener);
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
    } else {
      _controller.removeListener(_controllerListener);
    }

    if (widget.keyboardFocusNode != null) {
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

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktopPlatform = kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.macOS ||
              defaultTargetPlatform == TargetPlatform.windows ||
              defaultTargetPlatform == TargetPlatform.linux);

      final tableWidth = isDesktopPlatform
          ? constraints.maxWidth
          : constraints.maxWidth > constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
      final availableWidth = tableWidth - _extrasWidth;
      final tableHeight = constraints.maxHeight;

      return KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: _hoverRow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ------------------------------ Header ---------------------------
            if (_showHeader)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.headerHorizontalPadding,
                ),
                decoration: styles.headerDecoration,
                height: sizes.headerHeight,
                child: Row(
                  children: <Widget>[
                    if (_searchable && searchPosition == SearchPosition.left)
                      _SearchField(
                        decoration: _decoration,
                        controller: _searchFieldController,
                        focusNode: _searchFieldFocusNode,
                        onChanged: _onSearchFieldChanged,
                      ),
                    ..._header,
                    if (_searchable &&
                        searchPosition == SearchPosition.right) ...<Widget>[
                      const Spacer(),
                      _SearchField(
                        decoration: _decoration,
                        controller: _searchFieldController,
                        focusNode: _searchFieldFocusNode,
                        onChanged: _onSearchFieldChanged,
                      ),
                    ],
                  ],
                ),
              ),
            // ------------------------------ Table ----------------------------
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
                          columnOrder: _columnOrder,
                          columns: _columns,
                          tableWidth: availableWidth,
                          trailing: _columnHeaderTrailingActions,
                          onChecked: (value) {
                            _controller.toggleAllSelectedRows(
                                isSelected: value);
                            _onSelectionChanged?.call(_selectedRows.toList());
                          },
                          onColumnDragged: _controller.reOrderColumn,
                          onSort: _controller.setSort,
                          sorts: _controller.sorts,
                          currentRows: _currentRows,
                          selectedRows: _selectedRows,
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
                          child: Builder(
                            builder: (context) {
                              if (!_controller.isLoading &&
                                  _currentRows.isEmpty &&
                                  _emptyStateBuilder != null) {
                                return _emptyStateBuilder.call(context);
                              }

                              var itemCount = _activeRows.length;
                              final rowHeight = sizes.rowHeight;

                              if (_showEmptyRows &&
                                  (itemCount < tableHeight / rowHeight)) {
                                final emptyRows =
                                    tableHeight / rowHeight - itemCount;

                                itemCount += emptyRows.toInt();
                              }

                              return Stack(
                                children: <Widget>[
                                  ListView.separated(
                                    controller: _verticalScrollController,
                                    shrinkWrap: true,
                                    itemCount: itemCount,
                                    itemBuilder: (context, index) {
                                      if (index >= _activeRows.length) {
                                        return Container(
                                          height: sizes.rowHeight,
                                          color: colors.rowColor,
                                        );
                                      }

                                      return OperanceDataRow(
                                        columnOrder: _columnOrder,
                                        columns: _columns,
                                        row: _activeRows[index],
                                        index: index,
                                        tableWidth: availableWidth,
                                        onEnter: (_) {
                                          _controller.setHoveredRowIndex(index);
                                        },
                                        onExit: (_) {
                                          _controller.clearHoveredRowIndex();
                                        },
                                        onExpanded: _expandable
                                            ? _controller.toggleExpandedRow
                                            : null,
                                        expansionBuilder: _expansionBuilder,
                                        onChecked: _selectable
                                            ? (index, {isSelected}) {
                                                _controller.toggleSelectedRow(
                                                  _activeRows[index],
                                                );
                                                _onSelectionChanged?.call(
                                                  _selectedRows.toList(),
                                                );
                                              }
                                            : null,
                                        onRowPressed: _onRowPressed,
                                        decoration: _decoration,
                                        isHovered: _isHovered(index),
                                        isSelected: _isSelected(index),
                                        isExpanded: _isExpanded(index),
                                        showExpansionIcon: _expandable,
                                        showCheckbox: _selectable,
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
                                  if (_controller.isLoading)
                                    _loadingStateBuilder != null
                                        ? _loadingStateBuilder.call(context)
                                        : LinearProgressIndicator(
                                            backgroundColor:
                                                colors.loadingBackgroundColor,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              colors.loadingProgressColor,
                                            ),
                                            minHeight: sizes.loadingHeight,
                                            borderRadius:
                                                styles.loadingBorderRadius,
                                          ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ------------------------------ Footer ---------------------------
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
                              DropdownButton<int>(
                                value: _rowsPerPage,
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
                              ),
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
                          onPressed:
                              _controller.canGoNext || _controller.canFetchNext
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
        ),
      );
    });
  }

  /// Gets the order of the columns.
  List<int> get _columnOrder => _controller.columnOrder;

  /// Gets the current rows being displayed.
  List<T> get _currentRows => _controller.currentRows;

  /// Gets the rows that match the search criteria.
  Set<T> get _searchedRows => _controller.searchedRows;

  /// Gets the rows that are selected.
  Set<T> get _selectedRows => _controller.selectedRows;

  /// Gets the rows that are expanded.
  Map<int, bool> get _expandedRows => _controller.expandedRows;

  /// Gets the number of rows per page.
  int get _rowsPerPage => _controller.rowsPerPage;

  /// Gets the index of the currently hovered row.
  int? get _hoveredRowIndex => _controller.hoveredRowIndex;

  /// Gets the active rows, which are either the searched rows or the current
  /// rows.
  List<T> get _activeRows {
    return _searchedRows.isNotEmpty ? _searchedRows.toList() : _currentRows;
  }

  /// Calculates the maximum available width of the table.
  double _tableMaxWidth(double width) {
    final availableWidth = width - _extrasWidth;
    final totalColumnWidth = _columns.fold(0.0, (acc, column) {
      return acc + column.width.value(availableWidth);
    });

    return totalColumnWidth + _extrasWidth;
  }

  double get _extrasWidth {
    return (_expandable ? _expansionWidth : 0.0) +
        (_selectable ? _selectionWidth : 0.0) +
        (_columnHeaderTrailingActions.length * 50.0);
  }

  /// Checks if a row is selected.
  bool _isSelected(int index) => _selectedRows.contains(_currentRows[index]);

  /// Checks if a row is expanded.
  bool _isExpanded(int index) => _expandedRows[index] ?? false;

  /// Checks if a row is hovered.
  bool _isHovered(int index) => _hoveredRowIndex == index;

  /// Listener for the controller to update the state.
  void _controllerListener() => setState(() {});

  /// Listener for the search field to update the searched rows.
  void _searchFieldListener() {
    if (_searchFieldController.text.isEmpty) {
      _controller.clearSearchedRows();
    } else {
      final rows = _controller.allRows
          .where(
            (row) => _columns.any((column) {
              return column.getSearchableValue
                      ?.call(row)
                      .contains(_searchFieldController.text) ??
                  false;
            }),
          )
          .toList();

      if (rows.length == _searchedRows.length &&
          rows.every(_searchedRows.contains)) {
        return;
      }

      _controller.addSearchedRows(
        _controller.allRows
            .where(
              (row) => _columns.any((column) {
                return column.getSearchableValue
                        ?.call(row)
                        .contains(_searchFieldController.text) ??
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
  void _hoverRow(KeyEvent event) {
    final currentHoveredIndex = _hoveredRowIndex;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (currentHoveredIndex == null) {
          _controller.setHoveredRowIndex(0);
        } else if (currentHoveredIndex < _activeRows.length - 1) {
          _controller.setHoveredRowIndex(currentHoveredIndex + 1);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (currentHoveredIndex == null) {
          _controller.setHoveredRowIndex(0);
        } else if (currentHoveredIndex > 0) {
          _controller.setHoveredRowIndex(currentHoveredIndex - 1);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (currentHoveredIndex != null) {
          _controller.toggleExpandedRow(currentHoveredIndex);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (currentHoveredIndex != null) {
          _controller.toggleExpandedRow(currentHoveredIndex);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (currentHoveredIndex != null) {
          _onRowPressed?.call(_activeRows[currentHoveredIndex]);
        }
      }
    }
  }
}

/// A widget that represents a search field in the Operance data table.
class _SearchField extends StatelessWidget {
  /// Creates an instance of [_SearchField].
  ///
  /// The [decoration], [controller], and [focusNode] parameters are required.
  /// The [onChanged] parameter is optional.
  const _SearchField({
    required this.decoration,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  /// The decoration settings for the search field.
  final OperanceDataDecoration decoration;

  /// The controller for the search field.
  final TextEditingController controller;

  /// The focus node for the search field.
  final FocusNode focusNode;

  /// Callback when the search field value changes.
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: decoration.sizes.searchWidth,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration.styles.searchDecoration,
        onChanged: onChanged,
      ),
    );
  }
}
