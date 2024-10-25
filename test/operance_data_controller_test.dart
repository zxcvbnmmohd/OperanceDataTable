import 'package:flutter_test/flutter_test.dart';
import 'package:operance_datatable/src/filter.dart';
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
      final filter = Filter(
        field: 'name',
        type: FilterType.text,
        value: 'Alice',
        operator: 'equals',
      );
      controller.applyFilter('name', filter);
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should apply multiple filters', () {
      final nameFilter = Filter(
        field: 'name',
        type: FilterType.text,
        value: 'Alice',
        operator: 'equals',
      );
      final ageFilter = Filter(
        field: 'age',
        type: FilterType.numeric,
        value: 30,
        operator: '=',
      );
      controller
        ..applyFilter('name', nameFilter)
        ..applyFilter('age', ageFilter);
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should clear a specific filter', () {
      final filter = Filter(
        field: 'name',
        type: FilterType.text,
        value: 'Alice',
        operator: 'equals',
      );
      controller.applyFilter('name', filter);
      controller.clearFilter('name');
      expect(controller.searchedRows.length, 3); // All rows should be visible
    });

    test('should clear all filters', () {
      final nameFilter = Filter(
        field: 'name',
        type: FilterType.text,
        value: 'Alice',
        operator: 'equals',
      );
      final ageFilter = Filter(
        field: 'age',
        type: FilterType.numeric,
        value: 30,
        operator: '=',
      );
      controller
        ..applyFilter('name', nameFilter)
        ..applyFilter('age', ageFilter)
        ..clearAllFilters();
      expect(controller.searchedRows.length, 3); // All rows should be visible
    });

    test('should combine filters', () {
      final filters = {
        'name': Filter(
          field: 'name',
          type: FilterType.text,
          value: 'Alice',
          operator: 'equals',
        ),
        'age': Filter(
          field: 'age',
          type: FilterType.numeric,
          value: 30,
          operator: '=',
        ),
      };
      controller.combineFilters(filters);
      expect(controller.searchedRows.length, 1);
      expect(controller.searchedRows.first['name'], 'Alice');
    });

    test('should apply complex filter conditions', () {
      final ageFilter = Filter(
        field: 'age',
        type: FilterType.numeric,
        value: 25,
        operator: '>',
      );
      controller.applyFilter('age', ageFilter);
      expect(controller.searchedRows.length, 3); // Ages 30, 25, 35; 25 not >25
      expect(
          controller.searchedRows.any((row) => row['name'] == 'Bob'), isFalse);
    });
  });
}
