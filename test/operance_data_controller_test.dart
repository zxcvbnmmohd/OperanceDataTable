import 'package:flutter_test/flutter_test.dart';
import 'package:operance_datatable/src/operance_data_controller.dart';

void main() {
  group('OperanceDataController', () {
    late OperanceDataController<Map<String, dynamic>> controller;

    setUp(() {
      controller = OperanceDataController<Map<String, dynamic>>();
      controller.initialize(
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
    });

    test('should apply a single filter', () {
      controller.applyFilter('name', 'Alice');
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should apply multiple filters', () {
      controller
        ..applyFilter('name', 'Alice')
        ..applyFilter('age', 30);
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should clear a specific filter', () {
      controller
        ..applyFilter('name', 'Alice')
        ..clearFilter('name');
      expect(controller.searchedRows.length, 3); // All rows should be visible
    });

    test('should clear all filters', () {
      controller
        ..applyFilter('name', 'Alice')
        ..applyFilter('age', 30)
        ..clearAllFilters();
      expect(controller.searchedRows.length, 3); // All rows should be visible
    });

    test('should combine filters', () {
      controller.combineFilters({'name': 'Alice', 'age': 30});
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should apply complex filter conditions', () {
      controller.applyFilter('age', (int age) => age > 25);
      expect(controller.searchedRows.length, 2);
      expect(
        controller.searchedRows.any((row) => row['name'] == 'Bob'),
        isFalse,
      );
    });
  });
}
