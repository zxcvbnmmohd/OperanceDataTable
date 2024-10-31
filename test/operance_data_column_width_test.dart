// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column_width.dart';

void main() {
  group('Given an OperanceDataColumnWidth instance', () {
    group('When a fixed size is provided', () {
      test('Then it should return the fixed size', () {
        const columnWidth = OperanceDataColumnWidth(size: 100.0);

        expect(columnWidth.value(500.0), 100.0);
      });

      test('Then it should handle very large fixed size', () {
        const columnWidth = OperanceDataColumnWidth(size: 1000000.0);

        expect(columnWidth.value(500.0), 1000000.0);
      });

      test('Then it should handle very small fixed size', () {
        const columnWidth = OperanceDataColumnWidth(size: 0.1);

        expect(columnWidth.value(500.0), 0.1);
      });
    });

    group('When a factor is provided and size is not provided', () {
      test('Then it should calculate width based on the factor', () {
        const columnWidth = OperanceDataColumnWidth(factor: 0.2);

        expect(columnWidth.value(500.0), 100.0);
      });

      test('Then it should handle factor of 1', () {
        const columnWidth = OperanceDataColumnWidth(factor: 1.0);

        expect(columnWidth.value(500.0), 500.0);
      });

      test('Then it should handle factor close to 0', () {
        const columnWidth = OperanceDataColumnWidth(factor: 0.0001);

        expect(columnWidth.value(500.0), 0.05);
      });
    });

    group('When neither size nor factor is provided', () {
      test('Then it should use the default factor', () {
        const columnWidth = OperanceDataColumnWidth();

        expect(columnWidth.value(500.0), 75.0);
      });
    });

    group('When an invalid factor is provided', () {
      test(
          'Then it should throw an assertion error if factor is less than or '
          'equal to 0', () {
        expect(
          () => OperanceDataColumnWidth(factor: 0.0),
          throwsAssertionError,
        );
        expect(
          () => OperanceDataColumnWidth(factor: -0.1),
          throwsAssertionError,
        );
      });

      test(
          'Then it should throw an assertion error if factor is greater than '
          '1', () {
        expect(
          () => OperanceDataColumnWidth(factor: 1.1),
          throwsAssertionError,
        );
      });
    });
  });
}
