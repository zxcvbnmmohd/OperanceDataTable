// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/operance_data_column.dart';
import 'package:operance_datatable/src/operance_data_column_width.dart';

void main() {
  group('Given an OperanceDataColumn instance', () {
    group('When all required parameters are provided', () {
      test('Then it should create an instance with default values', () {
        final column = OperanceDataColumn<String>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item),
        );

        expect(column.name, 'name');
        expect(column.columnHeader, isA<Text>());
        expect(column.cellBuilder, isA<Function>());
        expect(column.getSearchableValue, isNull);
        expect(column.numeric, isFalse);
        expect(column.sortable, isFalse);
        expect(column.width, isA<OperanceDataColumnWidth>());
      });
    });

    group('When optional parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        final column = OperanceDataColumn<String>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item),
          getSearchableValue: (item) => item,
          numeric: true,
          sortable: true,
          width: const OperanceDataColumnWidth(size: 100.0),
        );

        expect(column.name, 'name');
        expect(column.columnHeader, isA<Text>());
        expect(column.cellBuilder, isA<Function>());
        expect(column.getSearchableValue, isA<Function>());
        expect(column.numeric, isTrue);
        expect(column.sortable, isTrue);
        expect(column.width, isA<OperanceDataColumnWidth>());
        expect(column.width.value(500.0), 100.0);
      });
    });

    group('When testing getSearchableValue', () {
      test('Then it should return the correct searchable value', () {
        final column = OperanceDataColumn<String>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item),
          getSearchableValue: (item) => item,
        );

        expect(column.getSearchableValue?.call('test'), 'test');
      });

      test('Then it should handle null values', () {
        final column = OperanceDataColumn<String?>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item ?? ''),
          getSearchableValue: (item) => item ?? '',
        );

        expect(column.getSearchableValue?.call(null), '');
      });

      test('Then it should handle empty strings', () {
        final column = OperanceDataColumn<String>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item),
          getSearchableValue: (item) => item,
        );

        expect(column.getSearchableValue?.call(''), '');
      });

      test('Then it should handle special characters', () {
        final column = OperanceDataColumn<String>(
          name: 'name',
          columnHeader: const Text('Header'),
          cellBuilder: (context, item) => Text(item),
          getSearchableValue: (item) => item,
        );

        expect(column.getSearchableValue?.call('!@#\$%^&*()'), '!@#\$%^&*()');
      });
    });
  });
}
