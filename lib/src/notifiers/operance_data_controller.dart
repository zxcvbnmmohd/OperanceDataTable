// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/values/values.dart';

/// Default value for the column order.
const defaultColumnOrder = <int>{};

/// Default value for the hidden columns.
const defaultHiddenColumns = <String>{};

/// Default value for the current page.
const defaultCurrentPage = 0;

/// Default value for the rows per page.
const defaultRowsPerPage = 25;

/// A controller class for managing the state and behavior of the
/// OperanceDataTable.
class OperanceDataController<T> extends ChangeNotifier {
  /// Creates an instance of [OperanceDataController].
  ///
  /// The [columnOrder] is the order of the columns.
  /// For example, `{0, 1, 2}`.
  /// The [hiddenColumns] are the columns that are hidden.
  /// For example, `{'id'}`.
  /// The [currentPage] is the current page index.
  /// For example, `0`.
  /// The [rowsPerPage] is the number of rows per page.
  /// For example, `25`.
  /// The [initialPage] is the initial page data. The first element is the
  /// rows and the second element is the indicator if there are more rows to
  /// fetch.
  /// For example, `const ([], false)`.
  /// The [onFetch] is the function to fetch data.
  /// The [onCurrentPageIndexChanged] is the callback to execute when the
  /// current page index changes.
  ///
  /// The [currentPage] must be non-negative.
  /// The [rowsPerPage] must be greater than 0.
  OperanceDataController({
    Set<int> columnOrder = defaultColumnOrder,
    Set<String> hiddenColumns = defaultHiddenColumns,
    int currentPage = defaultCurrentPage,
    int rowsPerPage = defaultRowsPerPage,
    PageData<T> initialPage = (const [], false),
    OnFetch<T>? onFetch,
    OnCurrentPageIndexChanged? onCurrentPageIndexChanged,
  })  : assert(currentPage >= 0, 'currentPage must be non-negative'),
        assert(rowsPerPage > 0, 'rowsPerPage must be greater than 0'),
        _onFetch = onFetch,
        _onCurrentPageIndexChanged = onCurrentPageIndexChanged,
        _hasMore = false,
        loadingNotifier = ValueNotifier<bool>(false),
        columnOrderNotifier = ColumnOrderNotifier(columnOrder: columnOrder),
        hiddenColumnsNotifier = HiddenColumnsNotifier(
          columns: Set<String>.from(hiddenColumns),
        ),
        currentPageNotifier = ValueNotifier<int>(currentPage),
        rowsPerPageNotifier = ValueNotifier<int>(rowsPerPage),
        paginateNotifier = ValueNotifier<(bool, bool)>((false, initialPage.$2)),
        sortsNotifier = SortsNotifier(sorts: <String, SortDirection>{}),
        hoveredRowNotifier = ValueNotifier<int?>(null),
        pagesNotifier = PagesNotifier<T>(
          pages: <Set<T>>{},
          rowsPerPage: rowsPerPage,
        ),
        expandedRowsNotifier = ExpandedRowsNotifier(rows: <int>{}),
        searchedRowsNotifier = SearchedRowsNotifier<T>(rows: <T>{}),
        selectedRowsNotifier = SelectedRowsNotifier<T>(rows: <T>{}) {
    if (initialPage.$1.isEmpty) {
      _fetchData(isInitial: true);
    } else {
      pagesNotifier.addAll = initialPage.$1;
      _hasMore = initialPage.$2;
    }
  }

  /// The function to fetch data.
  final OnFetch<T>? _onFetch;

  /// The callback to execute when the current page index changes.
  final OnCurrentPageIndexChanged? _onCurrentPageIndexChanged;

  /// Indicates if there are more rows to fetch.
  bool _hasMore;

  /// The notifier for the order of the columns.
  final ColumnOrderNotifier columnOrderNotifier;

  /// The notifier for the current page index.
  final ValueNotifier<int> currentPageNotifier;

  /// The notifier for expanded rows.
  final ExpandedRowsNotifier expandedRowsNotifier;

  /// The notifier for hidden columns.
  final HiddenColumnsNotifier hiddenColumnsNotifier;

  /// The notifier for the index of the hovered row.
  final ValueNotifier<int?> hoveredRowNotifier;

  /// Indicates if data is being loaded.
  final ValueNotifier<bool> loadingNotifier;

  /// The notifier for pagination to go to the next or previous page.
  final ValueNotifier<(bool, bool)> paginateNotifier;

  /// The notifier for pages of data.
  final PagesNotifier<T> pagesNotifier;

  /// The notifier for the number of rows per page.
  final ValueNotifier<int> rowsPerPageNotifier;

  /// The notifier for searched rows.
  final SearchedRowsNotifier<T> searchedRowsNotifier;

  /// The notifier for selected rows.
  final SelectedRowsNotifier<T> selectedRowsNotifier;

  /// The notifier for the sort directions of columns.
  final SortsNotifier sortsNotifier;

  /// Indicates if the next page can be navigated to.
  bool get _canGoNext {
    return currentPageNotifier.value < pagesNotifier.value.length - 1;
  }

  /// Indicates if the next page can be fetched.
  bool get _canFetchNext {
    return currentPageNotifier.value == pagesNotifier.value.length - 1 &&
        _hasMore;
  }

  /// Indicates if the previous page can be navigated to.
  bool get _canGoPrevious => currentPageNotifier.value > 0;

  /// Returns all the rows across all pages.
  Set<T> get rows => pagesNotifier.rows;

  Set<T> get currentRows {
    if (pagesNotifier.value.isEmpty) {
      return <T>{};
    }

    return pagesNotifier.value.elementAt(currentPageNotifier.value);
  }

  /// Returns the searched rows.
  Set<T> get searchedRows => searchedRowsNotifier.value.$1;

  /// Returns the selected rows.
  Set<T> get selectedRows => selectedRowsNotifier.value;

  // Update pagination notifier
  void _updatePaginateNotifier() {
    paginateNotifier.value = (_canGoPrevious, _canGoNext || _canFetchNext);
  }

  /// Resets the data and fetches the initial page.
  Future<void> _resetData() async {
    currentPageNotifier.value = 0;
    pagesNotifier.reset();
    _onCurrentPageIndexChanged?.call(currentPageNotifier.value);

    await _fetchData(isInitial: true);
  }

  /// Fetches the data.
  Future<void> _fetchData({bool isInitial = false}) async {
    if (loadingNotifier.value || _onFetch == null) {
      return;
    }

    loadingNotifier.value = true;

    try {
      final pageData = await _onFetch(
        rowsPerPageNotifier.value,
        sortsNotifier.value,
        isInitial: isInitial,
      );

      final rows = pageData.$1;
      _hasMore = pageData.$2;

      if (rows.isNotEmpty) {
        if (isInitial) {
          pagesNotifier.addAll = rows;
        } else {
          currentPageNotifier.value++;
          pagesNotifier.add = rows;
          _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      loadingNotifier.value = false;
      _updatePaginateNotifier();
    }
  }

  /// Navigates to the previous page.
  void previousPage() {
    if (_canGoPrevious) {
      currentPageNotifier.value--;
      _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
    }

    _updatePaginateNotifier();
  }

  /// Navigates to the next page. If the next page is not available, it fetches
  /// the next page.
  Future<void> nextPage() async {
    if (loadingNotifier.value) {
      return;
    }

    if (_canGoNext) {
      currentPageNotifier.value++;
      _onCurrentPageIndexChanged?.call(currentPageNotifier.value);
    } else if (_canFetchNext) {
      await _fetchData(isInitial: false);
    }

    _updatePaginateNotifier();
  }

  /// Toggles the sort direction of the column. The [column] is the column to
  /// toggle. If the column is already sorted, it will be unsorted. If the
  /// column is not sorted, it will be sorted in the [direction].
  Future<void> toggleSort({
    required String column,
    required SortDirection? direction,
  }) async {
    sortsNotifier.toggle(column: column, direction: direction);

    await _resetData();
  }

  /// Clears the sort directions. Resets the data.
  Future<void> resetSorts() async {
    sortsNotifier.reset();

    await _resetData();
  }

  /// Reorders the column. The [fromIndex] is the index of the column to reorder
  /// from. The [toIndex] is the index of the column to reorder to.
  void reorderColumn({required int fromIndex, required int toIndex}) {
    columnOrderNotifier.reorder(fromIndex: fromIndex, toIndex: toIndex);
  }

  /// Toggles the expansion of the row. The [index] is the index of the row to
  /// toggle. If the row is already expanded, it will be collapsed. If the row
  /// is not expanded, it will be expanded.
  set toggleExpandRow(int index) => expandedRowsNotifier.toggle = index;

  /// Toggles the visibility of the column. The [column] is the column to
  /// toggle. If the column is already hidden, it will be shown. If the column
  /// is not hidden, it will be hidden.
  set toggleHideColumn(String column) => hiddenColumnsNotifier.toggle = column;

  /// Toggles the selection of the row. The [row] is the row to toggle. If the
  /// row is already selected, it will be unselected. If the row is not
  /// selected, it will be selected.
  set toggleSelectRow(T row) => selectedRowsNotifier.toggle = row;

  /// Expands many rows. The [indexes] are the indexes of the rows to expand.
  set expandManyRows(List<int> indexes) {
    expandedRowsNotifier.expandMany = indexes;
  }

  /// Hides many columns. The [columns] are the columns to hide.
  set hideManyColumns(Set<String> columns) {
    hiddenColumnsNotifier.hideMany = columns;
  }

  /// Selects many rows. The [rows] are the rows to select.
  set selectManyRows(Set<T> rows) => selectedRowsNotifier.selectMany = rows;

  /// Adds a set of rows. The [rows] are the rows to add.
  /// The [isSearching] is set to `true`.
  set addSearchedRows(Set<T> rows) {
    searchedRowsNotifier.addRows = rows;
  }

  /// Sets the number of rows per page.
  set setRowsPerPage(int rowsPerPage) {
    rowsPerPageNotifier.value = rowsPerPage;
    pagesNotifier.rowsPerPage = rowsPerPage;

    hoveredRowNotifier.value = null;
    resetExpandedRows();
    resetSearchedRows();
    resetSelectedRows();

    _resetData();
  }

  /// Resets the column order to the original order.
  void resetColumnOrder() => columnOrderNotifier.reset();

  /// Collapses all rows.
  void resetExpandedRows() => expandedRowsNotifier.reset();

  /// Clears the hidden columns. Makes all columns visible.
  void resetHiddenColumns() => hiddenColumnsNotifier.reset();

  /// Clears the rows.
  void resetSearchedRows() => searchedRowsNotifier.reset();

  /// Unselect all rows.
  void resetSelectedRows() => selectedRowsNotifier.reset();

  /// Disposes the notifiers.
  @override
  void dispose() {
    columnOrderNotifier.dispose();
    currentPageNotifier.dispose();
    expandedRowsNotifier.dispose();
    hiddenColumnsNotifier.dispose();
    hoveredRowNotifier.dispose();
    loadingNotifier.dispose();
    paginateNotifier.dispose();
    pagesNotifier.dispose();
    rowsPerPageNotifier.dispose();
    searchedRowsNotifier.dispose();
    selectedRowsNotifier.dispose();
    sortsNotifier.dispose();

    super.dispose();
  }
}
