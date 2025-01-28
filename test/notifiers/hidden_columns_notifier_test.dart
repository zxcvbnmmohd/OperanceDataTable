// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/hidden_columns_notifier.dart';

void main() {
  group('Given an instance of HiddenColumnsNotifier', () {
    group('When created with default parameters', () {
      final notifier = HiddenColumnsNotifier();

      test('Then it should initialize with an empty set', () {
        expect(notifier.value, isEmpty);
      });
    });

    group('When created with specific columns', () {
      final initialColumns = <String>{'id', 'name', 'age'};
      final notifier = HiddenColumnsNotifier(columns: initialColumns);

      test('Then it should initialize with the provided set', () {
        expect(notifier.value, equals(initialColumns));
      });
    });

    group('When toggle is called on a hidden column', () {
      final initialColumns = <String>{'id'};
      final notifier = HiddenColumnsNotifier(columns: initialColumns);

      test('Then it should remove the column from the hidden set', () {
        notifier.toggle = 'id';
        expect(notifier.value, isEmpty);
      });
    });

    group('When toggle is called on a visible column', () {
      final notifier = HiddenColumnsNotifier(columns: <String>{});

      test('Then it should add the column to the hidden set', () {
        notifier.toggle = 'name';
        expect(notifier.value, equals(<String>{'name'}));
      });
    });

    group('When hideMany is called with a set of columns', () {
      var notifier = HiddenColumnsNotifier();

      test('Then it should add all the columns to the hidden set', () {
        notifier.hideMany = <String>{'id', 'name', 'age'};
        expect(notifier.value, equals(<String>{'id', 'name', 'age'}));
      });

      final initialColumns = <String>{'id', 'name'};

      notifier = HiddenColumnsNotifier(columns: initialColumns);

      test('Then it should not add duplicate columns', () {
        notifier.hideMany = <String>{'id', 'name', 'age'};
        expect(notifier.value, equals(<String>{'id', 'name', 'age'}));
      });
    });

    group('When reset is called', () {
      final initialColumns = <String>{'id', 'name', 'age'};
      final notifier = HiddenColumnsNotifier(columns: initialColumns);

      test('Then it should clear all hidden columns', () {
        notifier.reset();
        expect(notifier.value, isEmpty);
      });
    });

    group('When listeners are added', () {
      final notifier = HiddenColumnsNotifier(columns: <String>{});

      test('Then it should notify listeners on toggle', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..toggle = 'id';

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on hideMany', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..hideMany = <String>{'id', 'name', 'age'};

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
