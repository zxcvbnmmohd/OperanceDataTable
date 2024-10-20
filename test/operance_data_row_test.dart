// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_decoration.dart';
import 'package:operance_datatable/src/operance_data_row.dart';

void main() {
  group('Given an OperanceDataRow instance', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
      ),
    ];

    group('When all required parameters are provided', () {
      testWidgets(
        'Then it should create an instance with default values',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataRow<String>(
                  columnOrder: [0],
                  columns: columns,
                  row: 'Test Row',
                  index: 0,
                  tableWidth: 500.0,
                ),
              ),
            ),
          );

          expect(find.text('Test Row'), findsOneWidget);
        },
      );
    });

    group('When optional parameters are provided and row is expanded', () {
      testWidgets(
        'Then it should create an instance with the provided values',
        (tester) async {
          var expandedCalled = false;
          var checkedCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataRow<String>(
                  columnOrder: [0],
                  columns: columns,
                  row: 'Test Row',
                  index: 0,
                  tableWidth: 500.0,
                  onEnter: (_) {},
                  onExit: (_) {},
                  onExpanded: (_) => expandedCalled = true,
                  expansionBuilder: (item) => Text('Expanded $item'),
                  onChecked: (_, {isSelected}) => checkedCalled = true,
                  onRowPressed: (_) {},
                  decoration: const OperanceDataDecoration(),
                  isHovered: true,
                  isSelected: true,
                  isExpanded: true,
                  showExpansionIcon: true,
                  showCheckbox: true,
                ),
              ),
            ),
          );

          expect(find.text('Test Row'), findsOneWidget);
          expect(find.byType(Checkbox), findsOneWidget);
          expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
          expect(find.text('Expanded Test Row'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
          await tester.pumpAndSettle();

          expect(expandedCalled, isTrue);

          await tester.tap(find.byType(Checkbox));
          await tester.pumpAndSettle();

          expect(checkedCalled, isTrue);
        },
      );
    });

    group('When optional parameters are provided and row is not expanded', () {
      testWidgets(
        'Then it should create an instance with the provided values',
        (tester) async {
          var expandedCalled = false;
          var checkedCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataRow<String>(
                  columnOrder: [0],
                  columns: columns,
                  row: 'Test Row',
                  index: 0,
                  tableWidth: 500.0,
                  onEnter: (_) {},
                  onExit: (_) {},
                  onExpanded: (_) => expandedCalled = true,
                  expansionBuilder: (item) => Text('Expanded $item'),
                  onChecked: (_, {isSelected}) => checkedCalled = true,
                  onRowPressed: (_) {},
                  decoration: const OperanceDataDecoration(),
                  isHovered: true,
                  isSelected: true,
                  isExpanded: false,
                  showExpansionIcon: true,
                  showCheckbox: true,
                ),
              ),
            ),
          );

          expect(find.text('Test Row'), findsOneWidget);
          expect(find.byType(Checkbox), findsOneWidget);
          expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);

          await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
          await tester.pumpAndSettle();

          expect(expandedCalled, isTrue);

          await tester.tap(find.byType(Checkbox));
          await tester.pumpAndSettle();

          expect(checkedCalled, isTrue);
        },
      );
    });

    group(
        'When showExpansionIcon is true but onExpanded or expansionBuilder is '
        'null', () {
      test('Then it should assert', () {
        expect(
          () => OperanceDataRow<String>(
            columnOrder: [0],
            columns: columns,
            row: 'Test Row',
            index: 0,
            tableWidth: 500.0,
            showExpansionIcon: true,
          ),
          throwsAssertionError,
        );
      });
    });

    group('When showCheckbox is true but onChecked is null', () {
      test('Then it should assert', () {
        expect(
          () => OperanceDataRow<String>(
            columnOrder: [0],
            columns: columns,
            row: 'Test Row',
            index: 0,
            tableWidth: 500.0,
            showCheckbox: true,
          ),
          throwsAssertionError,
        );
      });
    });
  });
}
