// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/sorts_notifier.dart';
import 'package:operance_datatable/src/values/enumerations.dart';

void main() {
  group('Given an instance of SortsNotifier', () {
    group('When created with default parameters', () {
      final notifier = SortsNotifier();

      test('Then it should initialize with an empty map', () {
        expect(notifier.value, isEmpty);
      });
    });

    group('When created with specific sorts', () {
      final initialSorts = <String, SortDirection>{
        'id': SortDirection.ascending,
        'name': SortDirection.descending,
      };
      final notifier = SortsNotifier(sorts: initialSorts);

      test('Then it should initialize with the provided map', () {
        expect(notifier.value, equals(initialSorts));
      });
    });

    group('When toggle is called with a column and direction', () {
      final notifier = SortsNotifier(sorts: <String, SortDirection>{});

      test('Then it should add the column with the provided direction', () {
        notifier.toggle(column: 'id', direction: SortDirection.ascending);

        expect(
          notifier.value,
          equals(<String, SortDirection>{'id': SortDirection.ascending}),
        );
      });

      test(
          'Then it should update the direction of the column if it already '
          'exists', () {
        notifier
          ..toggle(column: 'id', direction: SortDirection.ascending)
          ..toggle(column: 'id', direction: SortDirection.descending);

        expect(
          notifier.value,
          equals(<String, SortDirection>{'id': SortDirection.descending}),
        );
      });

      test('Then it should remove the column if the direction is null', () {
        notifier
          ..toggle(column: 'id', direction: SortDirection.ascending)
          ..toggle(column: 'id', direction: null);

        expect(notifier.value, isEmpty);
      });
    });

    group('When reset is called', () {
      final initialSorts = <String, SortDirection>{
        'id': SortDirection.ascending,
        'name': SortDirection.descending,
      };
      final notifier = SortsNotifier(sorts: initialSorts);

      test('Then it should clear all sort directions', () {
        notifier.reset();

        expect(notifier.value, isEmpty);
      });
    });

    group('When listeners are added', () {
      final notifier = SortsNotifier(sorts: <String, SortDirection>{});

      test('Then it should notify listeners on toggle', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..toggle(column: 'id', direction: SortDirection.ascending);

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on reset', () {
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
