// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/misc.dart';

/// A controller class for managing the state and behavior of the
/// OperanceDataTable.
class OperanceDataController<T> extends ChangeNotifier {
  /// Creates an instance of [OperanceDataController].
  OperanceDataController();

  /// The order of the columns.
  final _columnOrder = <int>[];

  /// The hidden columns.
  final _hiddenColumns = <int>{};

  /// The pages of data.
  final _pages = <List<T>>[<T>[]];

  /// The set of searched rows.
  final _searchedRows = <T>{};

  /// The set of selected rows.
  final _selectedRows = <T>{};

  /// The map of expanded rows.
  final _expandedRows = <int, bool>{};

  /// The map of sort directions for columns.
  final _sorts = <String, SortDirection>{};

  /// Indicates if infinite scroll is enabled.
  var _infinityScroll = false;

  /// Indicates if there are more rows to fetch.
  var _hasMore = false;

  /// The number of rows per page.
  var _rowsPerPage = 25;

  /// The current page index.
  var _currentPageIndex = 0;

  /// Indicates if data is being loaded.
  var _isLoading = false;

  /// The function to fetch data.
  OnFetch<T>? _onFetch;

  /// The callback to execute when the current page index changes.
  ValueChanged<int>? _onCurrentPageIndexChanged;

  /// The index of the hovered row.
  int? _hoveredRowIndex;

  /// The function to fetch expanded row data.
  Future<T> Function(T)? _expandedRowFetcher;

  /// The map of expanded row data.
  final _expandedRowData = <int, Future<T>>{};

  /// Gets the order of the columns.
  List<int> get columnOrder => List<int>.unmodifiable(_columnOrder);

  /// Gets the hidden columns.
  Set<int> get hiddenColumns => Set<int>.unmodifiable(_hiddenColumns);

  /// Gets the visible columns.
  Set<int> get visibleColumns {
    return Set<int>.unmodifiable(
      _columnOrder
          .where((index) => !_hiddenColumns.contains(index))
          .map((index) => index)
          .toList(),
    );
  }

  /// Gets all rows across all pages.
  List<T> get allRows {
    return List<T>.unmodifiable(_pages.expand((element) => element).toList());
  }

  /// Gets the rows of the current page.
  List<T> get currentRows {
    if (_infinityScroll) {
      return List<T>.unmodifiable(allRows);
    } else {
      if (_currentPageIndex >= _pages.length) {
        return <T>[];
      }

      return List<T>.unmodifiable(_pages[_currentPageIndex]);
    }
  }

  /// Gets the set of searched rows.
  Set<T> get searchedRows => Set<T>.unmodifiable(_searchedRows);

  /// Gets the set of selected rows.
  Set<T> get selectedRows => Set<T>.unmodifiable(_selectedRows);

  /// Gets the map of expanded rows.
  Map<int, bool> get expandedRows => Map<int, bool>.unmodifiable(_expandedRows);

  /// Gets the map of sort directions for columns.
  Map<String, SortDirection> get sorts {
    return Map<String, SortDirection>.unmodifiable(_sorts);
  }

  /// Gets the number of rows per page.
  int get rowsPerPage => _rowsPerPage;

  /// Gets the current page index.
  int get currentPageIndex => _currentPageIndex;

  /// Gets the loading state.
  bool get isLoading => _isLoading;

  /// Gets the index of the hovered rpw.
  int? get hoveredRowIndex => _hoveredRowIndex;

  /// Indicates if the next page can be navigated to.
  bool get canGoNext => _currentPageIndex < _pages.length - 1;

  /// Indicates if the next page can be fetched.
  bool get canFetchNext => _currentPageIndex == _pages.length - 1 && _hasMore;

  /// Indicates if the previous page can be navigated to.
  bool get canGoPrevious => _currentPageIndex > 0;

  /// Initializes the controller with the given parameters.
  Future<void> initialize({
    List<int> columnOrder = const <int>[],
    PageData<T> initialPage = (const [], false),
    int currentPageIndex = 0,
    int rowsPerPage = 25,
    bool infiniteScroll = false,
    ValueChanged<int>? onCurrentPageIndexChanged,
    OnFetch<T>? onFetch,
    Future<T> Function(T)? expandedRowFetcher,
  }) async {
    _columnOrder
      ..clear()
      ..addAll(columnOrder);
    _currentPageIndex = currentPageIndex;
    _rowsPerPage = rowsPerPage;
    _infinityScroll = infiniteScroll;
    _onCurrentPageIndexChanged = onCurrentPageIndexChanged;
    _onFetch = onFetch;

    if (initialPage.$1.isEmpty) {
      await _fetchData(isInitial: true);
    } else {
      final rows = initialPage.$1;

      _pages
        ..clear()
        ..addAll(<List<T>>[
          for (int i = 0; i < rows.length; i += rowsPerPage)
            rows.skip(i).take(rowsPerPage).toList()
        ]);
      _hasMore = initialPage.$2;
      notifyListeners();
    }

    _expandedRowFetcher = expandedRowFetcher;
  }

  /// Navigates to the next page. If the next page is not available, it fetches
  /// the next page.
  Future<void> nextPage() async {
    if (_isLoading) {
      return;
    }

    if (canGoNext) {
      _currentPageIndex++;
      _onCurrentPageIndexChanged?.call(_currentPageIndex);
      notifyListeners();

      return;
    }

    if (canFetchNext) {
      await _fetchData(isInitial: false);
    }
  }

  /// Resets the data and fetches the initial page.
  Future<void> _resetData() async {
    _pages.clear();
    _currentPageIndex = 0;
    _onCurrentPageIndexChanged?.call(_currentPageIndex);

    await _fetchData(isInitial: true);
  }

  /// Fetches the data.
  Future<void> _fetchData({
    bool isInitial = false,
  }) async {
    if (_isLoading || _onFetch == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final pageData = await _onFetch!(
      _rowsPerPage,
      _sorts,
      isInitial: isInitial,
    );

    final rows = pageData.$1;
    _hasMore = pageData.$2;

    if (rows.isNotEmpty) {
      if (isInitial) {
        _pages
          ..clear()
          ..addAll(<List<T>>[
            for (int i = 0; i < rows.length; i += rowsPerPage)
              rows.skip(i).take(rowsPerPage).toList()
          ]);
      } else {
        _pages.add(rows);
        _currentPageIndex++;
        _onCurrentPageIndexChanged?.call(_currentPageIndex);
      }
    } else if (_pages.isEmpty) {
      _pages.add(<T>[]);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Navigates to the previous page.
  void previousPage() {
    if (canGoPrevious) {
      _currentPageIndex--;
      _onCurrentPageIndexChanged?.call(_currentPageIndex);
      notifyListeners();
    }
  }

  /// Reorders the columns.
  void reOrderColumn(int oldIndex, int newIndex) {
    final column = _columnOrder.removeAt(oldIndex);
    _columnOrder.insert(newIndex, column);
    notifyListeners();
  }

  /// Hides the column.
  void hideColumn(int index) {
    _hiddenColumns.add(index);
    notifyListeners();
  }

  /// Shows the column.
  void showColumn(int index) {
    _hiddenColumns.remove(index);
    notifyListeners();
  }

  /// Toggles the visibility of a column.
  void toggleColumnVisibility(int index) {
    if (_hiddenColumns.contains(index)) {
      showColumn(index);
    } else {
      hideColumn(index);
    }
  }

  /// Clears the hidden columns.
  void showAllColumns() {
    if (_hiddenColumns.isNotEmpty) {
      _hiddenColumns.clear();
      notifyListeners();
    }
  }

  /// Clears the searched rows.
  void clearSearchedRows() {
    _searchedRows.clear();
    notifyListeners();
  }

  /// Adds the searched rows.
  void addSearchedRows(List<T> rows) {
    _searchedRows
      ..clear()
      ..addAll(rows);
    notifyListeners();
  }

  /// Toggles the selection of a row.
  void toggleSelectedRow(T row) {
    if (_selectedRows.contains(row)) {
      _selectedRows.remove(row);
    } else {
      _selectedRows.add(row);
    }

    notifyListeners();
  }

  /// Toggles the selection of all rows.
  void toggleAllSelectedRows({bool? isSelected}) {
    if (isSelected == true) {
      _selectedRows.addAll(currentRows);
    } else {
      _selectedRows.clear();
    }

    notifyListeners();
  }

  /// Toggle the expansion of a row and fetch its data if needed
  Future<void> toggleExpandedRow(int index) async {
    final isExpanded = _expandedRows[index] ?? false;
    _expandedRows[index] = !isExpanded;

    if (!isExpanded && _expandedRowFetcher != null) {
      if (!_expandedRowData.containsKey(index)) {
        try {
          _expandedRowData[index] = Future.value(
            await _expandedRowFetcher!(allRows[index]),
          );
        } on Exception {
          _expandedRows[index] = false;
          _expandedRowData.remove(index);
        }
      }
    }

    notifyListeners();
  }

  /// Get expanded row data
  Future<T>? getExpandedRowData(int index) {
    return _expandedRows[index] == true ? _expandedRowData[index] : null;
  }

  /// Sets the sort direction for a column.
  Future<void> setSort(String columnName, SortDirection? direction) async {
    if (direction == null) {
      _sorts.remove(columnName);
    } else {
      _sorts[columnName] = direction;
    }

    notifyListeners();

    await _resetData();
  }

  /// Sets the number of rows per page.
  void setRowsPerPage(int rowsPerPage) {
    _rowsPerPage = rowsPerPage;
    _resetData();
  }

  /// Sets the index of the hovered row.
  void setHoveredRowIndex(int index) {
    _hoveredRowIndex = index;
    notifyListeners();
  }

  /// Clears the index of the hovered row.
  void clearHoveredRowIndex() {
    _hoveredRowIndex = null;
    notifyListeners();
  }

  /// Update row in cache
  void updateRow(T row) {
    final index = allRows.indexOf(row);

    if (index != -1) {
      final pageIndex = index ~/ _rowsPerPage;
      final rowIndex = index % _rowsPerPage;

      _pages[pageIndex][rowIndex] = row;
      notifyListeners();
    }
  }

  void clearUnusedExpandedData() {
    _expandedRowData.removeWhere((index, _) => _expandedRows[index] != true);
  }
}
