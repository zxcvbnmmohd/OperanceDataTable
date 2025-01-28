// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/models.dart';
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/values/values.dart';
import 'package:operance_datatable/src/widgets/operance_data_column_dropdown.dart';
import 'package:operance_datatable/src/widgets/operance_data_row.dart';
import 'package:operance_datatable/src/widgets/operance_data_search_field.dart';
import 'package:operance_datatable/src/widgets/operance_data_table.dart';

void main() {
  group('Given an instance of OperanceDataTable', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'id',
        columnHeader: const Text('ID'),
        cellBuilder: (context, item) => Text('ID: $item'),
        primary: true,
        sortable: true,
        getSearchableValue: (item) => item,
      ),
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text('Name: $item'),
        sortable: true,
        getSearchableValue: (item) => item,
      ),
    ];

    final currentPage = 0;

    PageData<String> initialPage({int length = 25}) {
      return (
        List<String>.generate(
            length, (index) => 'Page $currentPage Row $index'),
        false,
      );
    }

    // Future<(List<String>, bool)> fetch({int limit = 25}) async {
    //   final items = List<String>.generate(
    //     limit,
    //     (index) => 'Page $currentPage Row $index',
    //   );
    //
    //   currentPage++;
    //
    //   return Future.value((items, currentPage < 5));
    // }

    Widget buildApp({
      double? width,
      double? height,
      OnFetch<String>? onFetch,
      OperanceDataController<String>? controller,
      FocusNode? keyboardFocusNode,
      ScrollController? horizontalScrollController,
      ScrollController? verticalScrollController,
      TextEditingController? searchFieldController,
      FocusNode? searchFieldFocusNode,
      ValueChanged<String?>? onSearchFieldChanged,
      WidgetBuilder? loadingStateBuilder,
      WidgetBuilder? emptyStateBuilder,
      WidgetBuilder? emptySearchStateBuilder,
      Widget Function(BuildContext, String)? expansionBuilder,
      void Function(String)? onRowPressed,
      ValueChanged<Set<String>>? onSelectionChanged,
      OnCurrentPageIndexChanged? onCurrentPageIndexChanged,
      OperanceDataDecoration decoration = const OperanceDataDecoration(),
      PageData<String> initialPage = (const [], false),
      int currentPage = 0,
      List<Widget> header = const [],
      List<Widget> columnHeaderTrailingActions = const [],
      bool expandable = false,
      bool selectable = false,
      bool searchable = false,
      bool showHeader = false,
      bool showColumnHeader = true,
      bool showFooter = true,
      bool showEmptyRows = false,
      bool showRowsPerPageOptions = false,
      bool infiniteScroll = false,
      bool allowColumnReorder = false,
      bool allowColumnHiding = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: width,
            height: height,
            child: OperanceDataTable<String>(
              columns: columns,
              onFetch: onFetch,
              controller: controller,
              decoration: decoration,
              keyboardFocusNode: keyboardFocusNode,
              horizontalScrollController: horizontalScrollController,
              verticalScrollController: verticalScrollController,
              searchFieldController: searchFieldController,
              searchFieldFocusNode: searchFieldFocusNode,
              onSearchFieldChanged: onSearchFieldChanged,
              loadingStateBuilder: loadingStateBuilder,
              emptyStateBuilder: emptyStateBuilder,
              emptySearchStateBuilder: emptySearchStateBuilder,
              expansionBuilder: expansionBuilder,
              onRowPressed: onRowPressed,
              onSelectionChanged: onSelectionChanged,
              onCurrentPageIndexChanged: onCurrentPageIndexChanged,
              initialPage: initialPage,
              currentPage: currentPage,
              header: header,
              columnHeaderTrailingActions: columnHeaderTrailingActions,
              expandable: expandable,
              selectable: selectable,
              searchable: searchable,
              showHeader: showHeader,
              showColumnHeader: showColumnHeader,
              showFooter: showFooter,
              showEmptyRows: showEmptyRows,
              showRowsPerPageOptions: showRowsPerPageOptions,
              infiniteScroll: infiniteScroll,
              allowColumnReorder: allowColumnReorder,
              allowColumnHiding: allowColumnHiding,
            ),
          ),
        ),
      );
    }

    group('When rendering table with default values', () {
      testWidgets(
        'Then I expect the OperanceDataTable to be rendered',
        (tester) async {
          await tester.pumpWidget(buildApp());

          expect(find.byType(OperanceDataTable<String>), findsOneWidget);
        },
      );
    });

    group('When rendering the OperanceDataTable on different platforms', () {
      testWidgets('Then I expect it to render on MacOS', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        await tester.pumpWidget(buildApp(
          width: 800,
          height: 600,
        ));

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Then I expect it to render on Windows', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;

        await tester.pumpWidget(buildApp(
          width: 800,
          height: 600,
        ));

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('Then I expect it to render on Linux', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;

        await tester.pumpWidget(buildApp(
          width: 800,
          height: 600,
        ));

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Then I expect it to render with wider width on Desktop',
          (tester) async {
        await tester.pumpWidget(buildApp(
          width: 800,
          height: 600,
        ));

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Then I expect it to render with taller height on Desktop',
          (tester) async {
        await tester.pumpWidget(buildApp(
          width: 600,
          height: 800,
        ));

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Then I expect it to render taller height on Mobile',
          (tester) async {
        await tester.pumpWidget(buildApp(
          width: 600,
          height: 800,
        ));

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.mobile());

      testWidgets('Then I expect it to render with narrower width on Mobile',
          (tester) async {
        await tester.pumpWidget(buildApp(
          width: 600,
          height: 800,
        ));

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      });
    });

    group('When using search functionality', () {
      testWidgets('Then it should show search field when searchable is true',
          (tester) async {
        await tester.pumpWidget(buildApp(
          searchable: true,
          showHeader: true,
        ));
        expect(find.byType(OperanceDataSearchField), findsOneWidget);
      });

      testWidgets('Then it should filter rows when searching', (tester) async {
        final searchFieldController = TextEditingController();
        await tester.pumpWidget(buildApp(
          searchable: true,
          showHeader: true,
          searchFieldController: searchFieldController,
          initialPage: initialPage(),
        ));

        searchFieldController.text = 'Row 1';
        await tester.pump();

        expect(find.text('Row 1'), findsOneWidget);
        expect(find.text('Row 2'), findsNothing);
      });

      testWidgets('Then it should show empty search state when no results',
          (tester) async {
        await tester.pumpWidget(buildApp(
          initialPage: initialPage(),
          emptySearchStateBuilder: (context) => const Text('No results'),
          searchable: true,
          showHeader: true,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(OperanceDataSearchField), findsOneWidget);
        expect(find.byKey(const Key('search-field-right')), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Q');
        await tester.pumpAndSettle();

        expect(find.text('No results'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Row');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'non-existent');
        await tester.pumpAndSettle();

        expect(find.text('No results'), findsOneWidget);
      });

      testWidgets(
          'Then it should display search field on the left when searchable is '
          'true and searchPosition is left', (tester) async {
        await tester.pumpWidget(buildApp(
          searchable: true,
          showHeader: true,
          decoration: OperanceDataDecoration(
            ui: OperanceDataUI(
              searchPosition: SearchPosition.left,
            ),
          ),
        ));

        // Verify that the search field is displayed
        expect(find.byType(OperanceDataSearchField), findsOneWidget);
        expect(find.byKey(const Key('search-field-left')), findsOneWidget);

        // Verify that the search field is on the left
        final searchField = tester.widget<OperanceDataSearchField>(
          find.byType(OperanceDataSearchField),
        );
        expect(searchField.controller, isNotNull);
        expect(searchField.focusNode, isNotNull);
      });
    });

    group('When using selection', () {
      testWidgets('Then it should allow row selection when selectable is true',
          (tester) async {
        Set<String>? selectedRows;
        await tester.pumpWidget(buildApp(
          selectable: true,
          initialPage: initialPage(),
          onSelectionChanged: (rows) => selectedRows = rows,
        ));

        await tester.tap(find.byType(Checkbox).first);
        await tester.pump();

        expect(selectedRows, isNotNull);

        expect(selectedRows!.length, equals(25));
      });
    });

    group('When using pagination', () {
      testWidgets('Then it should display footer pagination controls',
          (tester) async {
        await tester.pumpWidget(buildApp(showFooter: true));
        expect(find.byType(IconButton), findsNWidgets(2)); // prev/next buttons
      });

      testWidgets('Then it should show rows per page options when enabled',
          (tester) async {
        await tester.pumpWidget(buildApp(
          showFooter: true,
          showRowsPerPageOptions: true,
        ));
        expect(find.byType(DropdownButton<int>), findsOneWidget);
      });
    });

    group('When using row expansion', () {
      testWidgets('Then it should expand rows when expandable is true',
          (tester) async {
        await tester.pumpWidget(buildApp(
          expandable: true,
          initialPage: initialPage(),
          expansionBuilder: (context, row) => Text('Expanded $row'),
        ));

        await tester.tap(find.byIcon(Icons.keyboard_arrow_up).first);
        await tester.pump();

        expect(find.text('Expanded Page 0 Row 0'), findsOneWidget);
      });
    });

    group('When empty states', () {
      testWidgets('Then it should show empty state when no data',
          (tester) async {
        await tester.pumpWidget(buildApp(
          emptyStateBuilder: (context) => const Text('No data'),
        ));
        expect(find.text('No data'), findsOneWidget);
      });

      testWidgets('Then it should show empty search state when no results',
          (tester) async {
        await tester.pumpWidget(buildApp(
          initialPage: initialPage(),
          emptySearchStateBuilder: (context) => const Text('No results'),
          searchable: true,
          showHeader: true,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(OperanceDataSearchField), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Q');
        await tester.pumpAndSettle();

        expect(find.text('No results'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Row');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'non-existent');
        await tester.pumpAndSettle();

        expect(find.text('No results'), findsOneWidget);
      });
    });

    group('When rendering table', () {
      testWidgets(
          'Then it should display search field on the left when searchable is '
          'true and searchPosition is left', (tester) async {
        await tester.pumpWidget(buildApp(
          searchable: true,
          showHeader: true,
          decoration: OperanceDataDecoration(
            ui: OperanceDataUI(
              searchPosition: SearchPosition.left,
            ),
          ),
        ));

        // Verify that the search field is displayed
        expect(find.byType(OperanceDataSearchField), findsOneWidget);

        // Verify that the search field is on the left
        final searchField = tester.widget<OperanceDataSearchField>(
          find.byType(OperanceDataSearchField),
        );
        expect(searchField.controller, isNotNull);
        expect(searchField.focusNode, isNotNull);

        // Verify that the SizedBox is present
        expect(find.byType(SizedBox), findsOneWidget);

        // Verify that the Spacer is present if header is empty
        expect(find.byType(Spacer), findsOneWidget);
      });

      testWidgets(
          'Then it should display column hiding dropdown when '
          'allowColumnHiding is true', (tester) async {
        await tester.pumpWidget(buildApp(
          allowColumnHiding: true,
          showHeader: true,
        ));

        expect(find.byType(OperanceDataColumnDropdown<String>), findsOneWidget);
      });

      testWidgets('Then it should show custom loading indicator when loading',
          (tester) async {
        final controller = OperanceDataController<String>();
        controller.loadingNotifier.value = true;

        await tester.pumpWidget(buildApp(
          controller: controller,
          loadingStateBuilder: (context) => const CircularProgressIndicator(),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Then it should show default loading indicator when loading',
          (tester) async {
        final controller = OperanceDataController<String>();
        controller.loadingNotifier.value = true;

        await tester.pumpWidget(buildApp(
          controller: controller,
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Then it should handle infinite scroll', (tester) async {
        final controller = OperanceDataController<String>();
        final scrollController = ScrollController();

        await tester.pumpWidget(buildApp(
          controller: controller,
          verticalScrollController: scrollController,
          infiniteScroll: true,
          onFetch: (limit, sort, {isInitial = false}) async {
            return (List<String>.generate(50, (index) => 'Row $index'), false);
          },
        ));

        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        await tester.pumpAndSettle();

        expect(find.text('Row 49'), findsOneWidget);
      });

      testWidgets('Then it should navigate pages', (tester) async {
        await tester.pumpWidget(buildApp(
          initialPage: initialPage(),
        ));

        final nextPageButton = find.byIcon(Icons.chevron_right);

        expect(nextPageButton, findsOneWidget);

        await tester.tap(nextPageButton);
        await tester.pumpAndSettle();

        final newPageRow = find.descendant(
          of: find.byType(OperanceDataRow<String>),
          matching: find.text('Row 26'),
        );

        expect(newPageRow, findsOneWidget);
      });
    });

    group('When rendering table with empty rows', () {
      testWidgets('Then it should add empty rows when showEmptyRows is true',
          (tester) async {
        await tester.pumpWidget(buildApp(
          height: 500.0,
          initialPage: initialPage(length: 1),
          showEmptyRows: true,
        ));

        await tester.pumpAndSettle();

        // Define the row height and calculate the expected number of empty rows
        final rowHeight = 50.0;
        final layoutBuilder = find.byKey(const Key('table-content'));
        final tableHeight = tester.getSize(layoutBuilder).height;
        final expectedEmptyRows =
            (tableHeight / rowHeight).ceil() - 1; // 1 item is already present

        // Verify that the expected number of empty rows are added
        expect(find.byKey(const Key('empty-row')),
            findsNWidgets(expectedEmptyRows));
      });
    });

    group('When handling rows per page', () {
      testWidgets('Then it should handle rows per page changes correctly',
          (tester) async {
        final controller = OperanceDataController<String>();
        await tester.pumpWidget(buildApp(
          controller: controller,
          initialPage: initialPage(),
          showFooter: true,
          showRowsPerPageOptions: true,
        ));

        await tester.tap(find.byType(DropdownButton<int>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('50').last);
        await tester.pumpAndSettle();

        expect(controller.rowsPerPageNotifier.value, equals(50));
      });
    });

    group('When handling keyboard events', () {
      testWidgets('should handle arrow down key event', (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();

        await tester.pumpWidget(buildApp(
          controller: controller,
          initialPage: initialPage(),
          keyboardFocusNode: keyboardFocusNode,
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Initial state with no hovered row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(controller.hoveredRowNotifier.value, 0);

        // Move to the next row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(controller.hoveredRowNotifier.value, 1);

        // Move to the last row
        for (var i = 0; i < 23; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pump();
        }
        expect(controller.hoveredRowNotifier.value, 24);
      });

      testWidgets('should handle arrow up key event', (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();

        await tester.pumpWidget(buildApp(
          controller: controller,
          initialPage: initialPage(),
          keyboardFocusNode: keyboardFocusNode,
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Move to the last row
        for (var i = 0; i < 25; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pump();
        }
        expect(controller.hoveredRowNotifier.value, 24);

        // Move to the previous row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(controller.hoveredRowNotifier.value, 23);

        // Move to the first row
        for (var i = 0; i < 23; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
          await tester.pump();
        }
        expect(controller.hoveredRowNotifier.value, 0);
      });

      testWidgets('should handle arrow left key event', (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();

        await tester.pumpWidget(buildApp(
          controller: controller,
          keyboardFocusNode: keyboardFocusNode,
          initialPage: initialPage(),
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Move to the first row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Toggle expand row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();
        expect(controller.expandedRowsNotifier.value, <int>{0});
      });

      testWidgets('should handle arrow right key event', (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();

        await tester.pumpWidget(buildApp(
          controller: controller,
          keyboardFocusNode: keyboardFocusNode,
          initialPage: initialPage(),
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Move to the first row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Toggle expand row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(controller.expandedRowsNotifier.value, <int>{0});
      });

      testWidgets('should handle arrow up key event when no row is hovered',
          (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();

        await tester.pumpWidget(buildApp(
          controller: controller,
          initialPage: initialPage(),
          keyboardFocusNode: keyboardFocusNode,
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Ensure no row is hovered initially
        expect(controller.hoveredRowNotifier.value, isNull);

        // Press arrow up key
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        // Verify that the first row is hovered
        expect(controller.hoveredRowNotifier.value, 0);
      });

      testWidgets('should handle enter key event', (tester) async {
        final controller = OperanceDataController<String>(
          initialPage: initialPage(),
        );
        final keyboardFocusNode = FocusNode();
        String? pressedRow;

        await tester.pumpWidget(buildApp(
          controller: controller,
          keyboardFocusNode: keyboardFocusNode,
          initialPage: initialPage(),
          onRowPressed: (row) => pressedRow = row,
        ));
        keyboardFocusNode.requestFocus();
        await tester.pump();

        // Move to the first row
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        // Press enter
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        expect(pressedRow, 'Page 0 Row 0');
      });
    });
  });
}
