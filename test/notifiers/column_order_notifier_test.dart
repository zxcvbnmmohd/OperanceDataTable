// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/column_order_notifier.dart';

void main() {
  group('Given an instance of ColumnOrderNotifier', () {
    group('When created with default parameters', () {
      test('Then it should initialize with an empty set', () {
        final notifier = ColumnOrderNotifier();

        expect(notifier.value, isEmpty);
      });
    });

    group('When created with a specific column order', () {
      final initialOrder = <int>{0, 1, 2};
      final notifier = ColumnOrderNotifier(columnOrder: initialOrder);

      test('Then it should initialize with the provided set', () {
        expect(notifier.value, equals(initialOrder));
      });
    });

    group('When reorder is called with valid indices', () {
      final initialOrder = <int>{0, 1, 2};
      final notifier = ColumnOrderNotifier(columnOrder: initialOrder);

      test('Then it should reorder the columns correctly', () {
        notifier.reorder(fromIndex: 0, toIndex: 2);

        final expectedOrder = <int>{1, 2, 0};

        expect(notifier.value, equals(expectedOrder));
      });
    });

    group('When reorder is called with invalid indices', () {
      final initialOrder = <int>{0, 1, 2};
      final notifier = ColumnOrderNotifier(columnOrder: initialOrder);

      test('Then it should throw an ArgumentError', () {
        expect(
          () => notifier.reorder(fromIndex: 3, toIndex: 2),
          throwsArgumentError,
        );

        expect(
          () => notifier.reorder(fromIndex: 0, toIndex: 3),
          throwsArgumentError,
        );
      });
    });

    group('When reset is called', () {
      final initialOrder = <int>{0, 1, 2};
      final notifier = ColumnOrderNotifier(columnOrder: initialOrder);

      test('Then it should reset the column order to the original order', () {
        notifier
          ..reorder(fromIndex: 0, toIndex: 2)
          ..reset();

        expect(notifier.value, equals(initialOrder));
      });
    });

    group('When listeners are added', () {
      final initialOrder = <int>{0, 1, 2};
      final notifier = ColumnOrderNotifier(columnOrder: initialOrder);

      test('Then it should notify listeners on reorder', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..reorder(fromIndex: 0, toIndex: 2);

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on reset', () {
        notifier.reorder(fromIndex: 0, toIndex: 2);

        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..reset();

        expect(notifyCalled, isTrue);
      });
    });
  });
}
