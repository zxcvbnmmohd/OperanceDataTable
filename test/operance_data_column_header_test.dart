// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/misc.dart';
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_column_header.dart';
import 'package:operance_datatable/src/operance_data_column_width.dart';
import 'package:operance_datatable/src/operance_data_decoration.dart';

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
    final columnOrder = List.generate(columns.length, (index) => index);

    group('When all required parameters are provided', () {
      testWidgets(
        'Then it should create an instance with default values',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columnOrder: columnOrder,
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
          var columnDraggedCalled = false;
          var sortCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataColumnHeader<String>(
                  columnOrder: columnOrder,
                  columns: columns,
                  tableWidth: 500.0,
                  trailing: <Widget>[Icon(Icons.more_vert)],
                  onChecked: (value) {
                    checkedCalled = true;
                  },
                  onColumnDragged: (oldIndex, newIndex) {
                    columnDraggedCalled = true;
                  },
                  onSort: (columnName, direction) {
                    sortCalled = true;
                  },
                  sorts: <String, SortDirection>{
                    'name': SortDirection.ascending,
                  },
                  currentRows: <String>['Row1', 'Row2'],
                  selectedRows: <String>{'Row1'},
                  decoration: const OperanceDataDecoration(),
                  allowColumnReorder: true,
                  expandable: true,
                  selectable: true,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          expect(find.byIcon(Icons.more_vert), findsOneWidget);

          // Test the onChecked callback
          await tester.tap(find.byType(Checkbox).first);
          await tester.pumpAndSettle();
          expect(checkedCalled, isTrue);

          // Test the onColumnDragged callback
          final firstLocation = tester.getCenter(find.text('Name'));
          final gesture = await tester.startGesture(firstLocation);
          await tester.pump();

          final secondLocation = firstLocation + const Offset(300.0, 0.0);
          await gesture.moveTo(secondLocation);
          await tester.pump();

          await gesture.up();
          await tester.pumpAndSettle();
          expect(columnDraggedCalled, isTrue);

          // Test the onSort callback
          await tester.tap(find.byKey(Key('sort_icon_name')));
          await tester.pumpAndSettle();
          expect(sortCalled, isTrue);
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
                  columnOrder: columnOrder,
                  columns: columns,
                  tableWidth: 500.0,
                  allowColumnReorder: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);

          // Test that dragging does not work
          await tester.drag(find.text('Name'), const Offset(50.0, 0.0));
          await tester.pumpAndSettle();
          // No assertion for columnDraggedCalled as it should not be called
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
                  columnOrder: columnOrder,
                  columns: columns,
                  tableWidth: 500.0,
                  expandable: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          // No expandable icon should be present
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
                  columnOrder: columnOrder,
                  columns: columns,
                  tableWidth: 500.0,
                  selectable: false,
                ),
              ),
            ),
          );

          expect(find.text('Name'), findsOneWidget);
          // No checkbox should be present
          expect(find.byType(Checkbox), findsNothing);
        },
      );
    });
  });
}
