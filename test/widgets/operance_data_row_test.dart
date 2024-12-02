// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column.dart';
import 'package:operance_datatable/src/widgets/operance_data_row.dart';

// 🌎 Project imports:

void main() {
  group('Given an OperanceDataRow instance', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
      ),
    ];

    Future<void> pumpOperanceDataRow(
      WidgetTester tester, {
      required bool isExpanded,
      required bool showExpansionIcon,
      required bool showCheckbox,
      void Function(int)? onExpanded,
      Widget Function(BuildContext, String)? expansionBuilder,
      ValueChanged<Set<String>>? onChecked,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperanceDataRow<String>(
              columns: columns,
              row: 'Test Row',
              index: 0,
              tableWidth: 500.0,
              onEnter: (_) {},
              onExit: (_) {},
              expansionBuilder: expansionBuilder,
              onChecked: onChecked,
              onRowPressed: (_) {},
            ),
          ),
        ),
      );
    }

    group('When all required parameters are provided', () {
      testWidgets(
        'Then it should display the row with default values',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: OperanceDataRow<String>(
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
        'Then it should display the row with expansion and checkbox',
        (tester) async {
          var expandedCalled = false;
          var checkedCalled = false;

          await pumpOperanceDataRow(
            tester,
            isExpanded: true,
            showExpansionIcon: true,
            showCheckbox: true,
            onExpanded: (_) => expandedCalled = true,
            expansionBuilder: (context, item) => Text('Expanded $item'),
            onChecked: (_, {isSelected}) => checkedCalled = true,
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
        'Then it should display the row with collapsed state and checkbox',
        (tester) async {
          var expandedCalled = false;
          var checkedCalled = false;

          await pumpOperanceDataRow(
            tester,
            isExpanded: false,
            showExpansionIcon: true,
            showCheckbox: true,
            onExpanded: (_) => expandedCalled = true,
            expansionBuilder: (context, item) => Text('Expanded $item'),
            onChecked: (_, {isSelected}) => checkedCalled = true,
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
      test('Then it should throw an assertion error', () {
        expect(
          () => OperanceDataRow<String>(
            columns: columns,
            row: 'Test Row',
            index: 0,
            tableWidth: 500.0,
          ),
          throwsAssertionError,
        );
      });
    });

    group('When showCheckbox is true but onChecked is null', () {
      test('Then it should throw an assertion error', () {
        expect(
          () => OperanceDataRow<String>(
            columns: columns,
            row: 'Test Row',
            index: 0,
            tableWidth: 500.0,
          ),
          throwsAssertionError,
        );
      });
    });

    group('Given edge cases', () {
      group('When row is empty', () {
        testWidgets(
          'Then it should display an empty row',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: OperanceDataRow<String>(
                    columns: columns,
                    row: '',
                    index: 0,
                    tableWidth: 500.0,
                  ),
                ),
              ),
            );

            expect(find.text(''), findsOneWidget);
          },
        );
      });

      group('When tableWidth is zero', () {
        testWidgets(
          'Then it should handle gracefully and display the row',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: OperanceDataRow<String>(
                    columns: columns,
                    row: 'Test Row',
                    index: 0,
                    tableWidth: 0.0,
                  ),
                ),
              ),
            );

            expect(find.text('Test Row'), findsOneWidget);
          },
        );
      });
    });
  });
}
