// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/values/values.dart';

void main() {
  group('Given an instance of OperanceDataController', () {
    group('When created with default parameters', () {
      final controller = OperanceDataController<String>();

      test('Then it should initialize with default values', () {
        expect(
          controller.columnOrderNotifier.value,
          equals(defaultColumnOrder),
        );
        expect(
          controller.hiddenColumnsNotifier.value,
          equals(defaultHiddenColumns),
        );
        expect(
          controller.currentPageNotifier.value,
          equals(defaultCurrentPage),
        );
        expect(
          controller.rowsPerPageNotifier.value,
          equals(defaultRowsPerPage),
        );
        expect(controller.loadingNotifier.value, isFalse);
        expect(controller.paginateNotifier.value, equals((false, false)));
        expect(controller.expandedRowsNotifier.value, isEmpty);
        expect(controller.searchedRowsNotifier.value.$1, isEmpty);
        expect(controller.searchedRowsNotifier.value.$2, isFalse);
        expect(controller.selectedRowsNotifier.value, isEmpty);
        expect(controller.sortsNotifier.value, isEmpty);
      });

      test('Then it should initialize with an empty set of pages', () {
        expect(controller.pagesNotifier.value, isEmpty);
      });

      test('Then it should initialize with an empty set of current rows', () {
        expect(controller.currentRows, isEmpty);
      });
    });

    group('When created with specific parameters', () {
      final controller = OperanceDataController<String>(
        columnOrder: <int>{0, 1, 2},
        hiddenColumns: <String>{'id'},
        currentPage: 0,
        rowsPerPage: 10,
        initialPage: (<String>['row1', 'row2', 'row3'], true),
        onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
          return (<String>['row4', 'row5'], false);
        },
      );

      test('Then it should initialize with the provided values', () {
        expect(controller.columnOrderNotifier.value, equals(<int>{0, 1, 2}));
        expect(controller.hiddenColumnsNotifier.value, equals(<String>{'id'}));
        expect(controller.currentPageNotifier.value, equals(0));
        expect(controller.rowsPerPageNotifier.value, equals(10));
        expect(controller.loadingNotifier.value, isFalse);
        expect(controller.paginateNotifier.value, equals((false, true)));
        expect(
          controller.pagesNotifier.value,
          equals(<Set<String>>{
            <String>{'row1', 'row2', 'row3'}
          }),
        );
        expect(controller.rows, <String>{'row1', 'row2', 'row3'});
        expect(
          controller.currentRows,
          equals(<String>{'row1', 'row2', 'row3'}),
        );
      });
    });

    group('When addSearchedRows is called', () {
      final controller = OperanceDataController<String>()
        ..addSearchedRows = <String>{'row1', 'row2', 'row3'};

      test('Then it should add the rows and set isSearching to true', () {
        expect(
          controller.searchedRows,
          equals(<String>{'row1', 'row2', 'row3'}),
        );
        expect(controller.searchedRowsNotifier.value.$2, isTrue);
      });
    });

    group('When toggleSearchMode is called', () {
      final controller = OperanceDataController<String>();

      test('Then it should toggle the search mode to true', () {
        controller.toggleSearchMode(searching: true);
        expect(controller.searchedRowsNotifier.value.$2, isTrue);
      });

      test('Then it should toggle the search mode to false', () {
        controller.toggleSearchMode(searching: false);
        expect(controller.searchedRowsNotifier.value.$2, isFalse);
      });
    });

    group('When resetSearchedRows is called', () {
      final controller = OperanceDataController<String>()
        ..addSearchedRows = <String>{'row1', 'row2', 'row3'}
        ..resetSearchedRows();

      test(
        'Then it should clear all searched rows and set isSearching to false',
        () {
          expect(controller.searchedRowsNotifier.value.$1, isEmpty);
          expect(controller.searchedRowsNotifier.value.$2, isFalse);
        },
      );
    });

    group('When toggleSort is called', () {
      final controller = OperanceDataController<String>(
        onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
          return (<String>['row4', 'row5'], false);
        },
      );

      test('Then it should toggle the sort direction and reset data', () async {
        await controller.toggleSort(
          column: 'id',
          direction: SortDirection.ascending,
        );

        expect(
          controller.sortsNotifier.value,
          equals(<String, SortDirection>{'id': SortDirection.ascending}),
        );
        expect(controller.loadingNotifier.value, isFalse);
        expect(
          controller.pagesNotifier.value,
          <Set<String>>{
            <String>{'row4', 'row5'}
          },
        );
        expect(controller.currentPageNotifier.value, equals(0));
      });
    });

    group('When resetSorts is called', () {
      final controller = OperanceDataController<String>(
        onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
          return (<String>['row4', 'row5'], false);
        },
      );

      controller.sortsNotifier.toggle(
        column: 'id',
        direction: SortDirection.ascending,
      );

      test('Then it should clear the sort directions and reset data', () async {
        await controller.resetSorts();

        expect(controller.sortsNotifier.value, isEmpty);
        expect(controller.loadingNotifier.value, isFalse);
        expect(controller.pagesNotifier.value, <Set<String>>{
          <String>{'row4', 'row5'}
        });
        expect(controller.currentPageNotifier.value, equals(0));
      });
    });

    group('When reorderColumn is called', () {
      final controller = OperanceDataController<String>();

      controller.columnOrderNotifier.value = <int>{0, 1, 2};
      controller.reorderColumn(fromIndex: 0, toIndex: 2);

      test('Then it should reorder the column', () {
        expect(controller.columnOrderNotifier.value, equals(<int>{1, 2, 0}));
      });
    });

    group('When toggleExpandRow is called', () {
      final controller = OperanceDataController<String>()
        ..toggleExpandRow = 'row';

      test('Then it should toggle the expansion of the row', () {
        expect(controller.expandedRows, isEmpty);
      });

      controller.toggleExpandRow = 'row';

      test('Then it should toggle the expansion of the row', () {
        expect(controller.expandedRows, isEmpty);
      });
    });

    group('When toggleHideColumn is called', () {
      final controller = OperanceDataController<String>()
        ..toggleHideColumn = 'id';

      test('Then it should toggle the visibility of the column', () {
        expect(controller.hiddenColumnsNotifier.value, isEmpty);
      });

      controller.toggleHideColumn = 'id';

      test('Then it should toggle the visibility of the column', () {
        expect(controller.hiddenColumnsNotifier.value, isEmpty);
      });
    });

    group('When toggleSelectRow is called', () {
      final controller = OperanceDataController<String>();

      test('Then it should toggle the selection of the row', () {
        controller.toggleSelectRow = 'row1';
        expect(controller.selectedRows, equals(<String>{'row1'}));
      });

      test('Then it should toggle the selection of the row', () {
        controller.toggleSelectRow = 'row1';
        expect(controller.selectedRows, isEmpty);
      });
    });

    group('When expandManyRows is called', () {
      final controller = OperanceDataController<String>()
        ..expandManyRows = <String>{'row1', 'row2', 'row3'};

      test('Then it should expand many rows', () {
        expect(
          controller.expandedRowsNotifier.value,
          equals(<String>{'row1', 'row2', 'row3'}),
        );
      });
    });

    group('When hideManyColumns is called', () {
      final controller = OperanceDataController<String>()
        ..hideManyColumns = <String>{'id', 'name'};

      test('Then it should hide many columns', () {
        expect(
          controller.hiddenColumnsNotifier.value,
          equals(<String>{'id', 'name'}),
        );
      });
    });

    group('When selectManyRows is called', () {
      final controller = OperanceDataController<String>()
        ..selectManyRows = <String>{'row1', 'row2', 'row3'};

      test('Then it should select many rows', () {
        expect(
          controller.selectedRowsNotifier.value,
          equals(<String>{'row1', 'row2', 'row3'}),
        );
      });
    });

    group('When setRowsPerPage is called', () {
      final controller = OperanceDataController<String>();

      test('Then it should set the number of rows per page and reset data', () {
        controller.setRowsPerPage = 10;

        expect(controller.rowsPerPageNotifier.value, equals(10));
        expect(controller.expandedRowsNotifier.value, isEmpty);
        expect(controller.searchedRowsNotifier.value.$1, isEmpty);
        expect(controller.selectedRowsNotifier.value, isEmpty);
        expect(controller.pagesNotifier.value, <Set<String>>{<String>{}});
        expect(controller.currentPageNotifier.value, equals(0));
      });
    });

    group('When resetColumnOrder is called', () {
      final controller = OperanceDataController<String>();

      controller.columnOrderNotifier.value = <int>{0, 1, 2};
      controller.resetColumnOrder();

      test('Then it should reset the column order to the original order', () {
        expect(
          controller.columnOrderNotifier.value,
          equals(defaultColumnOrder),
        );
      });
    });

    group('When resetExpandedRows is called', () {
      final controller = OperanceDataController<String>();

      controller.expandedRowsNotifier.value = <String>{'row1', 'row2', 'row3'};
      controller.resetExpandedRows();

      test('Then it should collapse all rows', () {
        expect(controller.expandedRowsNotifier.value, isEmpty);
      });
    });

    group('When resetHiddenColumns is called', () {
      final controller = OperanceDataController<String>();

      controller.hiddenColumnsNotifier.value = <String>{'id', 'name'};
      controller.resetHiddenColumns();

      test('Then it should clear the hidden columns', () {
        expect(controller.hiddenColumnsNotifier.value, isEmpty);
      });
    });

    group('When previousPage is called', () {
      final controller = OperanceDataController<String>();

      controller.currentPageNotifier.value = 1;
      controller.previousPage();

      test('Then it should navigate to the previous page', () {
        expect(controller.currentPageNotifier.value, equals(0));
        expect(controller.paginateNotifier.value, equals((false, false)));
      });
    });

    group('When nextPage is called', () {
      final pages = <Set<String>>{
        <String>{'row1', 'row2', 'row3'},
        <String>{'row4', 'row5'},
      };
      var currentPage = 0;

      final controller = OperanceDataController<String>(
        onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
          return (
            pages.elementAt(currentPage).toList(),
            currentPage < pages.length - 1,
          );
        },
      );

      test('Then it should fetch the next page if not available', () async {
        currentPage++;
        await controller.nextPage();

        expect(controller.currentPageNotifier.value, equals(1));
        expect(
          controller.pagesNotifier.value,
          equals(pages),
        );
        expect(controller.paginateNotifier.value, equals((true, false)));

        controller.previousPage();
        currentPage--;
      });

      test('Then it should navigate to the next page if available', () async {
        await controller.nextPage();

        expect(controller.currentPageNotifier.value, equals(1));
        expect(controller.paginateNotifier.value, equals((true, false)));
      });
    });

    group('When dispose is called', () {
      late OperanceDataController<String> controller;

      setUp(() {
        controller = OperanceDataController<String>();
      });

      test('Then it should dispose all notifiers', () {
        controller.dispose();

        expect(controller.columnOrderNotifier.value.isEmpty, isTrue);
        expect(controller.currentPageNotifier.value, 0);
        expect(controller.expandedRowsNotifier.value.isEmpty, isTrue);
        expect(controller.hiddenColumnsNotifier.value.isEmpty, isTrue);
        expect(controller.hoveredRowNotifier.value, isNull);
        expect(controller.loadingNotifier.value, isFalse);
        expect(controller.paginateNotifier.value, (false, false));
        expect(controller.pagesNotifier.value.isEmpty, isTrue);
        expect(controller.rowsPerPageNotifier.value, 25);
        expect(controller.searchedRowsNotifier.value.$1.isEmpty, isTrue);
        expect(controller.selectedRowsNotifier.value.isEmpty, isTrue);
        expect(controller.sortsNotifier.value.isEmpty, isTrue);
      });
    });

    group('Edge Cases', () {
      group('When onFetch returns empty rows', () {
        final controller = OperanceDataController<String>(
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            return (<String>[], false);
          },
        );

        test(
          'Then it should not add any rows and set _hasMore to false',
          () async {
            await controller.nextPage();
            expect(controller.pagesNotifier.value, isEmpty);
            expect(controller.hasMore, isFalse);
          },
        );
      });

      group('When onFetch returns rows and _hasMore is false', () {
        final mockPages = <Set<String>>{
          <String>{'row1', 'row2', 'row3'},
          <String>{'row4', 'row5', 'row6'},
        };
        var currentPage = 0;

        final controller = OperanceDataController<String>(
          onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
            return (
              mockPages.elementAt(currentPage).toList(),
              currentPage < mockPages.length - 1,
            );
          },
        );

        test('Then it should add the rows and set _hasMore to false', () async {
          currentPage++;

          await controller.nextPage();

          expect(controller.pagesNotifier.value, equals(mockPages));
          expect(controller.hasMore, isFalse);
        });
      });

      group('When previousPage is called on the first page', () {
        final controller = OperanceDataController<String>()..previousPage();

        test('Then it should not change the current page', () {
          expect(controller.currentPageNotifier.value, equals(0));
          expect(controller.paginateNotifier.value, equals((false, false)));
        });
      });

      group(
        'When nextPage is called on the last page with no more rows',
        () {
          final controller = OperanceDataController<String>(
            onFetch: (rowsPerPage, sorts, {isInitial = false}) async {
              return (<String>[], false);
            },
          );

          controller.pagesNotifier.addAll = <String>{
            'row1',
            'row2',
            'row3',
          }.toSet();
          controller.currentPageNotifier.value = 0;

          test('Then it should not change the current page', () async {
            await controller.nextPage();

            expect(controller.currentPageNotifier.value, equals(0));
            expect(controller.paginateNotifier.value, equals((false, false)));
          });
        },
      );

      group(
          'When setRowsPerPage is called with a value less than or equal to 0',
          () {
        final controller = OperanceDataController<String>();

        test('Then it should throw an assertion error', () {
          expect(
            () => controller.setRowsPerPage = 0,
            throwsAssertionError,
          );
        });

        test('Then it should throw an assertion error', () {
          expect(
            () => controller.setRowsPerPage = -1,
            throwsAssertionError,
          );
        });
      });
    });
  });
}
