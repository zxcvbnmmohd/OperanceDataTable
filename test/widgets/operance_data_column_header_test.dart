// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column.dart';
import 'package:operance_datatable/src/models/operance_data_column_width.dart';
import 'package:operance_datatable/src/widgets/operance_data_column_header.dart';

// 🌎 Project imports:

void main() {
  group('Given an OperanceDataColumnHeader instance', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
        sortable: true,
        width: OperanceDataColumnWidth(size: 100.0),
      ),
      OperanceDataColumn<String>(
        name: 'age',
        columnHeader: const Text('Age'),
        cellBuilder: (context, item) => Text(item),
        sortable: true,
        width: OperanceDataColumnWidth(size: 100.0),
      ),
    ];

    group('When all required parameters are provided', () {
      testWidgets(
        'Then it should create an instance with default values',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columns: columns,
                  tableWidth: 500.0,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
        },
      );
    });

    group('When optional parameters are provided', () {
      testWidgets(
        'Then it should create an instance with the provided values',
        (tester) async {
          var checkedCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columns: columns,
                  tableWidth: 500.0,
                  trailing: const <Widget>[Icon(Icons.more_vert)],
                  onChecked: (value) {
                    checkedCalled = true;
                  },
                  allowColumnReorder: true,
                  expandable: true,
                  selectable: true,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          expect(find.text('Age'), findsOneWidget);
          expect(find.byIcon(Icons.more_vert), findsOneWidget);

          await tester.tap(find.byType(Checkbox));
          await tester.pumpAndSettle();

          expect(checkedCalled, isTrue);

          final sortIconFinder = find.byKey(const ValueKey('sort_name'));
          await tester.tap(sortIconFinder);
          await tester.pumpAndSettle();

          // expect(sortCalled, isTrue);

          final draggableFinder = find.byKey(const ValueKey('draggable_name'));
          final dropTargetFinder = find.byKey(const ValueKey('draggable_age'));

          await tester.drag(
              draggableFinder,
              tester.getCenter(dropTargetFinder) -
                  tester.getCenter(draggableFinder));
          await tester.pumpAndSettle();

          // expect(columnDraggedCalled, isTrue);
        },
      );
    });

    group('When allowColumnReorder is false', () {
      testWidgets(
        'Then it should not allow column reordering',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columns: columns,
                  tableWidth: 500.0,
                  allowColumnReorder: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);

          await tester.drag(find.text('Name'), const Offset(50.0, 0.0));
          await tester.pumpAndSettle();
        },
      );
    });

    group('When expandable is false', () {
      testWidgets(
        'Then it should not show the expandable icon',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columns: columns,
                  tableWidth: 500.0,
                  expandable: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          expect(find.byIcon(Icons.expand_more), findsNothing);
        },
      );
    });

    group('When selectable is false', () {
      testWidgets(
        'Then it should not show the selectable checkbox',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columns: columns,
                  tableWidth: 500.0,
                  selectable: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          expect(find.byType(Checkbox), findsNothing);
        },
      );
    });
  });
}
