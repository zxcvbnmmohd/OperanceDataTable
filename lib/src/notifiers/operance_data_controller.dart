// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/values/values.dart';

/// A controller class for managing the state and behavior of the
/// OperanceDataTable.
class OperanceDataController<T> extends ChangeNotifier {
  /// Creates an instance of [OperanceDataController].
  OperanceDataController({
    Set<int> columnOrder = const <int>{},
    Set<int> hiddenColumns = const <int>{},
    PageData<T> initialPage = (const [], false),
    int currentPage = 0,
    int rowsPerPage = 25,
    OnFetch<T>? onFetch,
    ValueChanged<int>? onCurrentPageIndexChanged,
  })  : _hiddenColumns = hiddenColumns,
        _onFetch = onFetch,
        _onCurrentPageIndexChanged = onCurrentPageIndexChanged,
        _sorts = <String, SortDirection>{},
        _hasMore = false,
        loadingNotifier = ValueNotifier<bool>(false),
        paginateNotifier = ValueNotifier<(bool, bool)>((false, initialPage.$2)),
        currentPageNotifier = ValueNotifier<int>(currentPage),
        rowsPerPageNotifier = ValueNotifier<int>(rowsPerPage),
        hoveredRowNotifier = ValueNotifier<int?>(null),
        columnOrderNotifier = ColumnOrderNotifier(
          columnOrder: columnOrder,
        ),
        pagesNotifier = PagesNotifier<T>(
          pages: <Set<T>>{},
          rowsPerPage: rowsPerPage,
        ),
        expandedRowsNotifier = ExpandedRowsNotifier(rows: <int, bool>{}),
        searchedRowsNotifier = SearchedRowsNotifier<T>(rows: <T>{}),
        selectedRowsNotifier = SelectedRowsNotifier<T>(rows: <T>{}) {
    if (initialPage.$1.isEmpty) {
      _fetchData(isInitial: true);
    } else {
      pagesNotifier.addAll(initialPage.$1);
      _hasMore = initialPage.$2;
    }
  }

  /// The hidden columns.
  final Set<int> _hiddenColumns;

  /// The function to fetch data.
  final OnFetch<T>? _onFetch;

  /// The callback to execute when the current page index changes.
  final ValueChanged<int>? _onCurrentPageIndexChanged;

  /// The map of sort directions for columns.
  final Map<String, SortDirection> _sorts;

  /// Indicates if there are more rows to fetch.
  bool _hasMore;

  /// Indicates if data is being loaded.
  final ValueNotifier<bool> loadingNotifier;

  /// The notifier for pagination to go to the next or previous page.
  final ValueNotifier<(bool, bool)> paginateNotifier;

  /// The notifier for the current page index.
  final ValueNotifier<int> currentPageNotifier;

  /// The notifier for the number of rows per page.
  final ValueNotifier<int> rowsPerPageNotifier;

  /// The notifier for the index of the hovered row.
  final ValueNotifier<int?> hoveredRowNotifier;

  /// The notifier for the order of the columns.
  final ColumnOrderNotifier columnOrderNotifier;

  /// The notifier for pages of data.
  final PagesNotifier<T> pagesNotifier;

  /// The notifier for expanded rows.
  final ExpandedRowsNotifier expandedRowsNotifier;

  /// The notifier for searched rows.
  final SearchedRowsNotifier<T> searchedRowsNotifier;

  /// The notifier for selected rows.
  final SelectedRowsNotifier<T> selectedRowsNotifier;

  /// Gets the hidden columns.
  Set<int> get hiddenColumns => Set<int>.unmodifiable(_hiddenColumns);

  /// Gets the visible columns.
  Set<int> get visibleColumns {
    return Set<int>.unmodifiable(
      columnOrderNotifier.value
          .where((index) => !_hiddenColumns.contains(index))
          .map((index) => index)
          .toList(),
    );
  }

  /// Gets the map of sort directions for columns.
  Map<String, SortDirection> get sorts {
    return Map<String, SortDirection>.unmodifiable(_sorts);
  }

  /// Indicates if the next page can be navigated to.
  bool get canGoNext {
    return currentPageNotifier.value < pagesNotifier.value.length - 1;
  }

  /// Indicates if the next page can be fetched.
  bool get canFetchNext {
    return currentPageNotifier.value == pagesNotifier.value.length - 1 &&
        _hasMore;
  }

  /// Indicates if the previous page can be navigated to.
  bool get canGoPrevious => currentPageNotifier.value > 0;

  /// Navigates to the next page. If the next page is not available, it fetches
  /// the next page.
  Future<void> nextPage() async {
    if (loadingNotifier.value) {
      return;
    }

    if (canGoNext) {
      currentPageNotifier.value++;
      _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
    } else if (canFetchNext) {
      await _fetchData(isInitial: false);
    }

    paginateNotifier.value = (canGoPrevious, canGoNext || canFetchNext);
  }

  /// Resets the data and fetches the initial page.
  Future<void> _resetData() async {
    pagesNotifier.clear();
    currentPageNotifier.value = 0;
    _onCurrentPageIndexChanged?.call(currentPageNotifier.value);

    await _fetchData(isInitial: true);
  }

  /// Fetches the data.
  Future<void> _fetchData({
    bool isInitial = false,
  }) async {
    if (loadingNotifier.value || _onFetch == null) {
      return;
    }

    loadingNotifier.value = true;

    final pageData = await _onFetch(
      rowsPerPageNotifier.value,
      _sorts,
      isInitial: isInitial,
    );

    final rows = pageData.$1;
    _hasMore = pageData.$2;

    if (rows.isNotEmpty) {
      if (isInitial) {
        pagesNotifier.addAll(rows);
      } else {
        pagesNotifier.add(rows);
        currentPageNotifier.value++;
        _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
      }
    }

    loadingNotifier.value = false;
    paginateNotifier.value = (canGoPrevious, canGoNext || canFetchNext);
  }

  /// Navigates to the previous page.
  void previousPage() {
    if (canGoPrevious) {
      currentPageNotifier.value--;
      _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
    }

    paginateNotifier.value = (canGoPrevious, canGoNext || canFetchNext);
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
    rowsPerPageNotifier.value = rowsPerPage;
    pagesNotifier.rowsPerPage = rowsPerPage;

    hoveredRowNotifier.value = null;
    expandedRowsNotifier.clear();
    searchedRowsNotifier.clear();
    selectedRowsNotifier.clear();

    _resetData();
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    currentPageNotifier.dispose();
    rowsPerPageNotifier.dispose();
    hoveredRowNotifier.dispose();
    currentPageNotifier.dispose();
    pagesNotifier.dispose();
    expandedRowsNotifier.dispose();
    searchedRowsNotifier.dispose();
    selectedRowsNotifier.dispose();

    super.dispose();
  }
}
