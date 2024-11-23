// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/operance_datatable.dart';
import 'package:operance_datatable/src/widgets/operance_data_row.dart';
import 'package:operance_datatable/src/widgets/operance_data_search_field.dart';

void main() {
  group('Given an OperanceDataTable instance', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
        getSearchableValue: (item) => item,
      ),
      OperanceDataColumn<String>(
        name: 'age',
        columnHeader: const Text('Age'),
        cellBuilder: (context, item) => Text('age-$item'),
        getSearchableValue: (item) => item,
      ),
    ];
    final initialPage = (
      List<String>.generate(50, (index) => 'Row $index'),
      false,
    );

    Future<void> pumpOperanceDataTable(
      WidgetTester tester, {
      required List<OperanceDataColumn<String>> columns,
      OnFetch<String>? onFetch,
      OperanceDataController<String>? controller,
      FocusNode? keyboardFocusNode,
      ScrollController? horizontalScrollController,
      ScrollController? verticalScrollController,
      TextEditingController? searchFieldController,
      FocusNode? searchFieldFocusNode,
      ValueChanged<String?>? onSearchFieldChanged,
      WidgetBuilder? emptyStateBuilder,
      WidgetBuilder? loadingStateBuilder,
      Widget Function(String)? expansionBuilder,
      void Function(String)? onRowPressed,
      ValueChanged<Set<String>>? onSelectionChanged,
      ValueChanged<int>? onCurrentPageIndexChanged,
      double? width,
      double? height,
      OperanceDataDecoration decoration = const OperanceDataDecoration(),
      PageData<String> initialPage = const ([], false),
      int currentPageIndex = 0,
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
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: width,
              height: height,
              child: OperanceDataTable<String>(
                columns: columns,
                onFetch: onFetch,
                controller: controller,
                keyboardFocusNode: keyboardFocusNode,
                horizontalScrollController: horizontalScrollController,
                verticalScrollController: verticalScrollController,
                searchFieldController: searchFieldController,
                searchFieldFocusNode: searchFieldFocusNode,
                onSearchFieldChanged: onSearchFieldChanged,
                emptyStateBuilder: emptyStateBuilder,
                loadingStateBuilder: loadingStateBuilder,
                expansionBuilder: expansionBuilder,
                onRowPressed: onRowPressed,
                onSelectionChanged: onSelectionChanged,
                onCurrentPageIndexChanged: onCurrentPageIndexChanged,
                decoration: decoration,
                initialPage: initialPage,
                currentPageIndex: currentPageIndex,
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
              ),
            ),
          ),
        ),
      );
    }

    group('When all required parameters are provided', () {
      testWidgets('Then it should display the table with default values',
          (tester) async {
        await pumpOperanceDataTable(tester, columns: columns);

        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Age'), findsOneWidget);
      });
    });

    group('When handling an empty state with a custom loader', () {
      testWidgets('Then it should show empty state builder when no rows',
          (tester) async {
        const emptyStateText = 'No data available';

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          initialPage: (<String>[], true),
          emptyStateBuilder: (_) => const Text(emptyStateText),
        );

        await tester.pumpAndSettle();

        expect(find.text(emptyStateText), findsOneWidget);
      });

      testWidgets('Then it should show a custom loading state when loading',
          (tester) async {
        final controller = OperanceDataController<String>();
        const loadingText = 'Loading...';
        final completer = Completer<PageData<String>>();
        var fetchCalled = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          onFetch: (limit, sort, {isInitial = false}) {
            fetchCalled = true;
            return completer.future;
          },
          loadingStateBuilder: (_) => Text(loadingText),
        );

        await tester.pump();

        expect(fetchCalled, isTrue);

        await tester.pump(Duration.zero);

        expect(find.text(loadingText), findsOneWidget);

        completer.complete((
          List<String>.generate(50, (index) => 'Row$index'),
          false,
        ));

        await tester.pumpAndSettle();

        expect(find.text(loadingText), findsNothing);
        expect(find.text('Row0'), findsOneWidget);
      });
    });

    group('When handling empty states with the default loader', () {
      testWidgets('Then it should show default loading state when loading',
          (tester) async {
        final controller = OperanceDataController<String>();
        final completer = Completer<PageData<String>>();
        var fetchCalled = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          onFetch: (limit, sort, {isInitial = false}) {
            fetchCalled = true;
            return completer.future;
          },
        );

        await tester.pump();

        expect(fetchCalled, isTrue);

        await tester.pump(Duration.zero);

        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        completer.complete(initialPage);

        await tester.pumpAndSettle();

        expect(find.byType(LinearProgressIndicator), findsNothing);
        expect(find.text('Row 0'), findsOneWidget);
      });

      testWidgets('Then it should show a custom loading state when loading',
          (tester) async {
        final controller = OperanceDataController<String>();
        const loadingText = 'Loading...';
        final completer = Completer<PageData<String>>();
        var fetchCalled = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          onFetch: (limit, sort, {isInitial = false}) {
            fetchCalled = true;
            return completer.future;
          },
          loadingStateBuilder: (_) => const Center(
            child: Text(loadingText),
          ),
        );

        await tester.pump();

        expect(fetchCalled, isTrue);

        await tester.pump(Duration.zero);

        expect(find.text(loadingText), findsOneWidget);

        completer.complete((
          List<String>.generate(50, (index) => 'Row$index'),
          false,
        ));

        await tester.pumpAndSettle();

        expect(find.text(loadingText), findsNothing);
        expect(find.text('Row0'), findsOneWidget);
      });
    });

    group('When the header is shown', () {
      testWidgets('Then it should display the search field on the left',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          showHeader: true,
          searchable: true,
          decoration: OperanceDataDecoration(
            ui: OperanceDataUI(
              searchPosition: SearchPosition.left,
            ),
          ),
        );

        expect(find.byType(OperanceDataSearchField), findsOneWidget);
      });

      testWidgets('Then it should display the search field on the right',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          showHeader: true,
          searchable: true,
          decoration: OperanceDataDecoration(
            ui: OperanceDataUI(
              searchPosition: SearchPosition.right,
            ),
          ),
        );

        expect(find.byType(OperanceDataSearchField), findsOneWidget);
      });
    });

    group('When handling rows per page', () {
      testWidgets('Then it should handle rows per page changes correctly',
          (tester) async {
        final controller = OperanceDataController<String>();
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          showFooter: true,
          showRowsPerPageOptions: true,
        );

        await tester.tap(find.byType(DropdownButton<int>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('50').last);
        await tester.pumpAndSettle();

        expect(controller.rowsPerPage, equals(50));
      });

      testWidgets('Then it should toggle row selection on checkbox tap',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          selectable: true,
        );

        final firstCheckbox = find.byType(Checkbox).first;

        await tester.tap(firstCheckbox);
        await tester.pump();

        expect(controller.selectedRows, contains('Row 0'));

        await tester.tap(firstCheckbox);
        await tester.pump();

        expect(controller.selectedRows, isNot(contains('Row 0')));
      });
    });

    group('When handling empty rows display', () {
      testWidgets(
          'Then it should display empty rows when showEmptyRows is true',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          showEmptyRows: true,
          initialPage: (const <String>[], true), // Empty data
        );

        expect(find.byType(Container), findsWidgets); // Empty row containers
      });
    });

    group('When handling row hover events', () {
      testWidgets('Then it should handle row hover events correctly',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          controller: controller,
          columns: columns,
          initialPage: initialPage,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, equals(0));
      });
    });

    group('When interacting with the table', () {
      testWidgets('Then it should sort columns', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          showHeader: true,
          showColumnHeader: true,
        );

        await tester.tap(find.text('Name'));
        await tester.pumpAndSettle();

        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Age'), findsOneWidget);
      });

      testWidgets('Then it should select rows', (tester) async {
        final controller = OperanceDataController<String>();
        var checkedCalled = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          onSelectionChanged: (items) {
            checkedCalled = true;
          },
          showHeader: true,
          selectable: true,
        );

        final firstCheckbox = find.byType(Checkbox).first;

        await tester.tap(firstCheckbox);
        await tester.pumpAndSettle();

        expect(controller.selectedRows, contains('Row 0'));

        await tester.tap(firstCheckbox);
        await tester.pump();

        expect(controller.selectedRows, isNot(contains('Row 0')));
        expect(checkedCalled, isTrue);
      });

      testWidgets('Then it should handle row hover events correctly',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          onRowPressed: (_) {},
        );

        final firstRow = find.byType(OperanceDataRow<String>).first;

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await gesture.moveTo(tester.getCenter(firstRow));
        await tester.pumpAndSettle();

        expect(controller.hoveredRowIndex, equals(0));

        await gesture.moveTo(Offset.zero);
        await tester.pumpAndSettle();

        expect(controller.hoveredRowIndex, isNull);

        await gesture.removePointer();
      });

      testWidgets(
          'Then it should select and deselect rows through onChecked callback',
          (tester) async {
        final controller = OperanceDataController<String>();
        var selectionChangedCalled = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          onSelectionChanged: (items) {
            selectionChangedCalled = true;
          },
          showHeader: true,
          selectable: true, // Ensure selectable is set to true
        );

        expect(find.byType(OperanceDataRow<String>), findsWidgets);

        final firstRowCheckbox = find.descendant(
          of: find.byType(OperanceDataRow<String>).first,
          matching: find.byType(Checkbox),
        );

        expect(
          firstRowCheckbox,
          findsOneWidget,
          reason: 'First row checkbox should be present.',
        );

        await tester.tap(firstRowCheckbox);
        await tester.pumpAndSettle();

        expect(controller.selectedRows, contains('Row 0'));
        expect(selectionChangedCalled, isTrue);

        await tester.tap(firstRowCheckbox);
        await tester.pumpAndSettle();

        expect(controller.selectedRows, isNot(contains('Row 0')));
      });

      testWidgets('Then it should expand rows', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          initialPage: initialPage,
          showHeader: true,
          expandable: true,
          expansionBuilder: Text.new,
        );

        expect(find.byKey(ValueKey('collapsed_0')), findsOneWidget);

        await tester.tap(find.byKey(ValueKey('collapsed_0')));
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('expanded_0')), findsOneWidget);

        await tester.tap(find.byKey(ValueKey('expanded_0')));
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('collapsed_0')), findsOneWidget);
      });

      testWidgets('Then it should show search field on the left',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          searchable: true,
          showHeader: true,
        );

        expect(find.byType(OperanceDataSearchField), findsOneWidget);
      });

      testWidgets('Then it should search rows', (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          searchable: true,
          showHeader: true,
        );

        await tester.enterText(find.byType(TextField), 'R');
        await tester.pumpAndSettle();

        expect(controller.searchedRows, isNotEmpty);

        await tester.enterText(find.byType(TextField), '');
        await tester.pumpAndSettle();

        expect(controller.searchedRows, isEmpty);
      });

      testWidgets('Then it should navigate pages', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          initialPage: initialPage,
        );

        final nextPageButton = find.byIcon(Icons.chevron_right);

        expect(nextPageButton, findsOneWidget);

        await tester.tap(nextPageButton);
        await tester.pumpAndSettle();

        final newPageRow = find.descendant(
          of: find.byType(OperanceDataRow<String>),
          matching: find.text('Row 25'),
        );

        expect(newPageRow, findsOneWidget);
      });
    });

    group('When handling keyboard navigation', () {
      testWidgets('Then it should handle keyboard events correctly',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          expansionBuilder: Text.new,
          expandable: true,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, equals(0));

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(controller.hoveredRowIndex, equals(0));

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();

        expect(controller.expandedRows.value[0], isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();

        expect(controller.expandedRows.value[0], isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
      });

      testWidgets('Then it should navigate rows with arrow keys',
          (tester) async {
        final controller = OperanceDataController<String>();
        final focusNode = FocusNode();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          keyboardFocusNode: focusNode,
          initialPage: initialPage,
        );

        focusNode.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, 0);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, 1);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(controller.hoveredRowIndex, 0);
      });

      testWidgets('Then it should expand and collapse rows with arrow keys',
          (tester) async {
        final controller = OperanceDataController<String>();
        final focusNode = FocusNode();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          keyboardFocusNode: focusNode,
          initialPage: initialPage,
          expansionBuilder: Text.new,
          expandable: true,
        );

        focusNode.requestFocus();

        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, 0);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();

        expect(controller.expandedRows.value[0], true);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();

        expect(controller.expandedRows.value[0], false);
      });

      testWidgets('Then it should trigger row press with enter key',
          (tester) async {
        final controller = OperanceDataController<String>();
        final focusNode = FocusNode();
        var rowPressed = false;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          keyboardFocusNode: focusNode,
          initialPage: initialPage,
          onRowPressed: (_) => rowPressed = true,
        );

        focusNode.requestFocus();

        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        expect(controller.hoveredRowIndex, 0);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(rowPressed, true);
      });

      testWidgets(
          'Then it should set hovered row index to 0 when arrow up is pressed '
          'and no row is hovered', (tester) async {
        final controller = OperanceDataController<String>();
        final focusNode = FocusNode();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          keyboardFocusNode: focusNode,
          initialPage: initialPage,
        );

        focusNode.requestFocus();

        await tester.pump();

        expect(controller.hoveredRowIndex, isNull);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(controller.hoveredRowIndex, equals(0));
      });
    });

    group('When handling scroll events', () {
      testWidgets('Then it should trigger infinite scroll correctly',
          (tester) async {
        final controller = OperanceDataController<String>();
        final verticalScrollController = ScrollController();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          verticalScrollController: verticalScrollController,
          initialPage: initialPage,
          infiniteScroll: true,
        );

        verticalScrollController.position.jumpTo(
          verticalScrollController.position.maxScrollExtent,
        );

        await tester.pump();

        expect(controller.currentPageIndex, greaterThan(0));
      });
    });

    group('When handling search with left position', () {
      testWidgets('Then it should show search field on the left',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          initialPage: initialPage,
          searchable: true,
          showHeader: true,
        );

        await tester.enterText(find.byType(TextField), 'Row 1');
        await tester.pump();

        expect(controller.searchedRows, isNotEmpty);
        expect(
          controller.searchedRows.every((row) => row.contains('Row 1')),
          isTrue,
        );
      });

      testWidgets(
          'Then it should not update searched rows if search results do '
          'not change', (tester) async {
        final searchFieldController = TextEditingController();
        final focusNode = FocusNode();
        final initialRows = List<String>.generate(10, (index) => 'Row $index');
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          controller: controller,
          searchFieldController: searchFieldController,
          searchFieldFocusNode: focusNode,
          initialPage: (initialRows, false),
          searchable: true,
          showHeader: true,
        );

        searchFieldController.text = 'Row';

        await tester.pumpAndSettle();

        expect(controller.searchedRows.length, initialRows.length);

        searchFieldController.text = 'Row ';

        await tester.pumpAndSettle();

        expect(controller.searchedRows.length, initialRows.length);
      });
    });

    group('OperanceDataTable platform-specific tests', () {
      testWidgets('Test on macOS platform', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 800,
          height: 600,
        );

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Test on Windows platform', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 800,
          height: 600,
        );

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('Test on Linux platform', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 800,
          height: 600,
        );

        expect(find.byType(OperanceDataTable<String>), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Test tableWidth logic with wider width', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 800,
          height: 600,
        );

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Test tableWidth logic with taller height', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 600,
          height: 800,
        );

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.desktop());

      testWidgets('Test tableWidth logic with taller height', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
          width: 600,
          height: 800,
        );

        final table = tester.widget<OperanceDataTable<String>>(
          find.byType(OperanceDataTable<String>),
        );

        expect(table, isNotNull);
      }, variant: TargetPlatformVariant.mobile());
    });

    group('When disposing resources', () {
      testWidgets('Then it should dispose the controller if not provided',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        await tester.pumpWidget(const SizedBox());

        expect(controller.dispose, returnsNormally);
      });

      testWidgets('Then it should not dispose the provided controller',
          (tester) async {
        final controller = OperanceDataController<String>();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        await tester.pumpWidget(const SizedBox());

        expect(() => controller.removeListener(() {}), returnsNormally);
      });

      testWidgets(
          'Then it should dispose the keyboard focus node if not provided',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(() => FocusNode().dispose(), returnsNormally);
      });

      testWidgets('Then it should not dispose the provided keyboard focus node',
          (tester) async {
        final focusNode = FocusNode();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          keyboardFocusNode: focusNode,
        );

        expect(focusNode.dispose, returnsNormally);
      });

      testWidgets(
          'Then it should dispose the horizontal scroll controller if not '
          'provided', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(() => ScrollController().dispose(), returnsNormally);
      });

      testWidgets(
          'Then it should not dispose the provided horizontal scroll '
          'controller', (tester) async {
        final horizontalScrollController = ScrollController();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(horizontalScrollController.dispose, returnsNormally);
      });

      testWidgets(
          'Then it should dispose the vertical scroll controller if not '
          'provided', (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(() => ScrollController().dispose(), returnsNormally);
      });

      testWidgets(
          'Then it should not dispose the provided vertical scroll controller',
          (tester) async {
        final verticalScrollController = ScrollController();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(verticalScrollController.dispose, returnsNormally);
      });

      testWidgets(
          'Then it should dispose the search field controller if not provided',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(() => TextEditingController().dispose(), returnsNormally);
      });

      testWidgets(
          'Then it should not dispose the provided search field controller',
          (tester) async {
        final searchFieldController = TextEditingController();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          searchFieldController: searchFieldController,
        );

        expect(searchFieldController.dispose, returnsNormally);
      });

      testWidgets(
          'Then it should dispose the search field focus node if not provided',
          (tester) async {
        await pumpOperanceDataTable(
          tester,
          columns: columns,
        );

        expect(() => FocusNode().dispose(), returnsNormally);
      });

      testWidgets(
          'Then it should not dispose the provided search field focus node',
          (tester) async {
        final searchFieldFocusNode = FocusNode();

        await pumpOperanceDataTable(
          tester,
          columns: columns,
          searchFieldFocusNode: searchFieldFocusNode,
        );

        expect(searchFieldFocusNode.dispose, returnsNormally);
      });
    });
  });
}
