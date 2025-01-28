// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/expanded_rows_notifier.dart';

void main() {
  group('Given an instance of ExpandedRowsNotifier', () {
    group('When created with default parameters', () {
      final notifier = ExpandedRowsNotifier();

      test('Then it should initialize with an empty set', () {
        expect(notifier.value, isEmpty);
      });
    });

    group('When created with specific rows', () {
      final initialRows = <int>{0, 1, 2};
      final notifier = ExpandedRowsNotifier(rows: initialRows);

      test('Then it should initialize with the provided set', () {
        expect(notifier.value, equals(initialRows));
      });
    });

    group('When toggle is called on an unexpanded row', () {
      final initialRows = <int>{0, 1, 2};
      final notifier = ExpandedRowsNotifier(rows: initialRows);

      test('Then it should add the row to the expanded set', () {
        notifier.toggle = 0;
        expect(notifier.value, equals(<int>{1, 2}));
      });
    });

    group('When toggle is called on an already expanded row', () {
      final initialRows = <int>{0, 1, 2};
      final notifier = ExpandedRowsNotifier(rows: initialRows);

      test('Then it should remove the row from the expanded set', () {
        notifier.toggle = 0;
        expect(notifier.value, equals(<int>{1, 2}));
      });
    });

    group('When expandMany is called with a list of indexes', () {
      var notifier = ExpandedRowsNotifier();

      test('Then it should add all the indexes to the expanded set', () {
        notifier.expandMany = <int>{0, 1, 2};
        expect(notifier.value, equals(<int>{0, 1, 2}));
      });

      final initialRows = <int>{0, 1};
      notifier = ExpandedRowsNotifier(rows: initialRows);

      test('Then it should not add duplicate indexes', () {
        notifier.expandMany = <int>{0, 1, 2};
        expect(notifier.value, equals(<int>{0, 1, 2}));
      });
    });

    group('When reset is called', () {
      final initialRows = <int>{0, 1, 2};
      final notifier = ExpandedRowsNotifier(rows: initialRows);

      test('Then it should clear all expanded rows', () {
        notifier.reset();
        expect(notifier.value, isEmpty);
      });
    });

    group('When listeners are added', () {
      final notifier = ExpandedRowsNotifier(rows: <int>{});

      test('Then it should notify listeners on toggle', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..toggle = 0;

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on expandMany', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..expandMany = <int>{0, 1, 2};

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on reset', () {
        notifier.toggle = 0;

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
