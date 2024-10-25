// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operance_datatable/operance_datatable.dart';
import 'package:operance_datatable/src/filter.dart';

void main() {
  group('OperanceDataTable Widget Tests', () {
    testWidgets('should open filter dialog and apply filter', (tester) async {
      final controller = OperanceDataController<Map<String, dynamic>>();

      await controller.initialize(
        columnOrder: [0, 1, 2],
        initialPage: (
          [
            {'name': 'Alice', 'age': 30},
            {'name': 'Bob', 'age': 25},
            {'name': 'Charlie', 'age': 35},
          ],
          false
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperanceDataTable<Map<String, dynamic>>(
              controller: controller,
              columns: [
                OperanceDataColumn<Map<String, dynamic>>(
                  name: 'name',
                  columnHeader: Text('Name'),
                  cellBuilder: (context, row) => Text(row['name']),
                  filterType: FilterType.text, // Specify filter type
                ),
                OperanceDataColumn<Map<String, dynamic>>(
                  name: 'age',
                  columnHeader: Text('Age'),
                  cellBuilder: (context, row) => Text(row['age'].toString()),
                  filterType: FilterType.numeric, // Specify filter type
                ),
              ],
            ),
          ),
        ),
      );

      // Open filter dialog for 'name' column
      await tester.tap(find.descendant(
        of: find.widgetWithText(Row, 'Name'),
        matching: find.byIcon(Icons.filter_list),
      ));
      await tester.pumpAndSettle();

      // Enter filter value and apply
      await tester.enterText(find.byType(TextField), 'Alice');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify filter applied
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });
  });
}
