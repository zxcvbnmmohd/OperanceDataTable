// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/values/values.dart';

void main() {
  const emptyPage = (<String>[], false);
  final initialPage = (
    List<String>.generate(50, (index) => 'Row$index'),
    true,
  );
  const columnOrder = <int>[0, 1, 2];
  const currentPageIndex = 1;
  const rowsPerPage = 25;
  const rowsPerPage10 = 10;
  const initialPageWithRows = (<String>['Row1', 'Row2'], false);

  group('Given an OperanceDataController instance', () {
    late OperanceDataController<String> controller;

    setUp(() {
      controller = OperanceDataController<String>();
    });

    Future<void> initializeController({
      List<int> columnOrder = const <int>[],
      PageData<String> initialPage = emptyPage,
      int currentPageIndex = 0,
      int rowsPerPage = 25,
      bool infiniteScroll = false,
      OnFetch<String>? onFetch,
    }) async {
      await controller.initialize(
        columnOrder: columnOrder,
        initialPage: initialPage,
        currentPageIndex: currentPageIndex,
        rowsPerPage: rowsPerPage,
        infiniteScroll: infiniteScroll,
        onFetch: onFetch,
      );
    }

    test('Then it should create an instance of OperanceDataController', () {
      expect(controller, isA<OperanceDataController<String>>());
    });

    group('When currentPageIndex is out of bounds', () {
      test(
          'Then it should add empty list when fetching initial data returns '
          'empty and pages is empty', () async {
        var fetchCalled = false;

        await initializeController(
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            fetchCalled = true;
            return emptyPage;
          },
        );

        expect(fetchCalled, isTrue);
        expect(controller.pages.length, 1);
        expect(controller.pages.first, isEmpty);
      });

      test('Then currentRows should return an empty list', () async {
        await initializeController(
          initialPage: emptyPage,
          currentPageIndex: currentPageIndex,
        );

        expect(controller.currentRows, isEmpty);
      });
    });

    group('When fetching data with empty pages', () {
      test('Then it should add an empty list to pages', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: emptyPage,
        );

        expect(controller.currentRows, isEmpty);
        expect(controller.allRows, isEmpty);
      });
    });

    group('When fetching data with empty pages and no rows returned', () {
      test('Then it should add an empty list to pages', () async {
        await initializeController(
          initialPage: emptyPage,
        );

        await controller.nextPage();

        expect(controller.currentRows, isEmpty);
        expect(controller.allRows, isEmpty);
        expect(controller.pages.length, 1);
        expect(controller.pages.first, isEmpty);
      });
    });

    group('When initialized with default values', () {
      test('Then it should have default values', () {
        expect(controller.columnOrder, isEmpty);
        expect(controller.hiddenColumns, isEmpty);
        expect(controller.currentRows, isEmpty);
        expect(controller.searchedRows, isEmpty);
        expect(controller.selectedRows, isEmpty);
        expect(controller.expandedRows, isEmpty);
        expect(controller.sorts, isEmpty);
        expect(controller.rowsPerPage, rowsPerPage);
        expect(controller.currentPageIndex, 0);
        expect(controller.isLoading, isFalse);
        expect(controller.hoveredRowIndex, isNull);
        expect(controller.canGoNext, isFalse);
        expect(controller.canFetchNext, isFalse);
        expect(controller.canGoPrevious, isFalse);
      });
    });

    group('When initialized with parameters', () {
      test('Then it should set the provided values', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
          currentPageIndex: currentPageIndex,
          rowsPerPage: rowsPerPage10,
          infiniteScroll: true,
        );

        expect(controller.columnOrder, columnOrder);
        expect(controller.currentRows, <String>['Row1', 'Row2']);
        expect(controller.rowsPerPage, rowsPerPage10);
        expect(controller.currentPageIndex, currentPageIndex);
        expect(controller.canGoNext, isFalse);
        expect(controller.canFetchNext, isFalse);
        expect(controller.canGoPrevious, isTrue);
      });
    });

    group('When navigating pages', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPage,
          rowsPerPage: rowsPerPage10,
        );
      });

      test('Then it should navigate to the next page', () async {
        await controller.nextPage();

        expect(controller.currentPageIndex, currentPageIndex);
        expect(
          controller.currentRows,
          initialPage.$1.sublist(10, 20),
        );
      });

      test('Then it should navigate to the previous page', () async {
        await controller.nextPage();

        controller.previousPage();

        expect(controller.currentPageIndex, 0);
        expect(controller.currentRows, initialPage.$1.sublist(0, 10));
      });
    });

    group('When sorting columns', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPageWithRows,
        );
      });

      test('Then it should set the sort direction', () async {
        await controller.setSort('name', SortDirection.ascending);

        expect(
          controller.sorts,
          <String, SortDirection>{
            'name': SortDirection.ascending,
          },
        );
      });

      test('Then it should remove the sort direction', () async {
        await controller.setSort('name', SortDirection.ascending);
        await controller.setSort('name', null);

        expect(controller.sorts, isEmpty);
      });
    });

    group('When selecting rows', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPageWithRows,
        );
      });

      test('Then it should toggle the selection of a row', () {
        controller.selectedRows.toggle('Row1');
        expect(controller.selectedRows, <String>{'Row1'});

        controller.selectedRows.toggle('Row1');
        expect(controller.selectedRows, isEmpty);
      });

      test('Then it should toggle the selection of all rows', () {
        controller.selectedRows.selectAll(
          <String>{'Row1', 'Row2'},
        );
        expect(controller.selectedRows, <String>{'Row1', 'Row2'});
      });
    });

    group('When expanding rows', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPageWithRows,
        );
      });

      test('Then it should toggle the expansion of a row', () {
        controller.toggleExpandedRow(0);
        expect(controller.expandedRows, <int, bool>{0: true});

        controller.toggleExpandedRow(0);
        expect(controller.expandedRows, <int, bool>{0: false});
      });
    });

    group('When hovering rows', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPageWithRows,
        );
      });

      test('Then it should set the hovered row index', () {
        controller.setHoveredRowIndex(1);
        expect(controller.hoveredRowIndex, 1);
      });

      test('Then it should clear the hovered row index', () {
        controller
          ..setHoveredRowIndex(1)
          ..clearHoveredRowIndex();
        expect(controller.hoveredRowIndex, isNull);
      });
    });

    group('When updating rows', () {
      setUp(() async {
        await initializeController(
          initialPage: initialPageWithRows,
        );
      });

      test('Then it should update the row in cache', () {
        controller.updateRow('Row1');
        expect(
          controller.currentRows,
          <String>['Row1', 'Row2'],
        );
      });
    });

    group('When getting visible columns', () {
      test('Then it should return the visible columns', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
        );

        controller.hideColumn(1);
        expect(controller.visibleColumns, <int>{0, 2});
      });
    });

    group('When hiding and showing columns', () {
      test('Then it should hide and show columns correctly', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
        );

        controller.hideColumn(1);
        expect(controller.hiddenColumns, <int>{1});

        controller.showColumn(1);
        expect(controller.hiddenColumns, isEmpty);
      });

      test('Then it should toggle column visibility', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
        );

        controller.toggleColumnVisibility(1);
        expect(controller.hiddenColumns, <int>{1});

        controller.toggleColumnVisibility(1);
        expect(controller.hiddenColumns, isEmpty);
      });

      test('Then it should show all columns', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
        );

        controller
          ..hideColumn(1)
          ..showAllColumns();
        expect(controller.hiddenColumns, isEmpty);
      });
    });

    group('When managing searched rows', () {
      test('Then it should clear searched rows', () async {
        await initializeController(
          initialPage: initialPageWithRows,
        );

        controller
          ..addSearchedRows(<String>['Row1'])
          ..clearSearchedRows();
        expect(controller.searchedRows, isEmpty);
      });

      test('Then it should add searched rows', () async {
        await initializeController(
          initialPage: initialPageWithRows,
        );

        controller.addSearchedRows(<String>['Row1']);
        expect(controller.searchedRows, <String>{'Row1'});
      });
    });

    group('When setting rows per page', () {
      test('Then it should set the number of rows per page', () async {
        await initializeController(
          initialPage: initialPageWithRows,
        );

        controller.setRowsPerPage(50);
        expect(controller.rowsPerPage, 50);
      });
    });

    group('When reordering columns', () {
      test('Then it should reorder columns', () async {
        await initializeController(
          columnOrder: columnOrder,
          initialPage: initialPageWithRows,
        );

        controller.reOrderColumn(0, 2);
        expect(controller.columnOrder, [1, 2, 0]);
      });
    });

    group('When fetching data', () {
      test('Then it should fetch initial data if initialPage is empty',
          () async {
        var fetchCalled = false;

        await initializeController(
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            fetchCalled = true;
            return initialPageWithRows;
          },
        );

        expect(fetchCalled, isTrue);
      });

      test('Then it should not fetch data if initialPage is not empty',
          () async {
        var fetchCalled = false;

        await initializeController(
          initialPage: initialPageWithRows,
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            fetchCalled = true;
            return initialPageWithRows;
          },
        );

        expect(fetchCalled, isFalse);
      });

      test('Then it should fetch next page data if canFetchNext is true',
          () async {
        var fetchCalled = false;

        await initializeController(
          initialPage: initialPage,
          rowsPerPage: rowsPerPage10,
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            fetchCalled = true;
            return (List.generate(10, (index) => 'Row${index + 50}'), false);
          },
        );
        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();

        expect(fetchCalled, isTrue);
      });

      test('Then it should not fetch next page data if canFetchNext is false',
          () async {
        var fetchCalled = false;

        await initializeController(
          initialPage: (List.generate(50, (index) => 'Row$index'), false),
          rowsPerPage: rowsPerPage10,
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            fetchCalled = true;
            return (List.generate(10, (index) => 'Row${index + 50}'), false);
          },
        );

        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();
        await controller.nextPage();

        expect(fetchCalled, isFalse);
      });
    });
  });
}
