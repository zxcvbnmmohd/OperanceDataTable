// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/selected_rows_notifier.dart';

void main() {
  group('Given an instance of SelectedRowsNotifier', () {
    group('When created with default parameters', () {
      final notifier = SelectedRowsNotifier<String>();

      test('Then it should initialize with an empty set', () {
        expect(notifier.value, isEmpty);
      });
    });

    group('When created with specific rows', () {
      final initialRows = <String>{'row1', 'row2', 'row3'};
      final notifier = SelectedRowsNotifier<String>(rows: initialRows);

      test('Then it should initialize with the provided set', () {
        expect(notifier.value, equals(initialRows));
      });
    });

    group('When toggle is called on a selected row', () {
      final initialRows = <String>{'row1'};
      final notifier = SelectedRowsNotifier<String>(rows: initialRows);

      test('Then it should remove the row from the selected set', () {
        notifier.toggle = 'row1';
        expect(notifier.value, isEmpty);
      });
    });

    group('When toggle is called on a non-selected row', () {
      final notifier = SelectedRowsNotifier<String>(rows: <String>{});

      test('Then it should add the row to the selected set', () {
        notifier.toggle = 'row1';
        expect(notifier.value, equals(<String>{'row1'}));
      });
    });

    group('When selectMany is called with a set of rows', () {
      var notifier = SelectedRowsNotifier<String>();

      test(
          'Then it should clear the current selection '
          'and add all the provided rows', () {
        notifier.selectMany = <String>{'row1', 'row2', 'row3'};
        expect(notifier.value, equals(<String>{'row1', 'row2', 'row3'}));
      });

      final initialRows = <String>{'row1', 'row2'};
      notifier = SelectedRowsNotifier<String>(rows: initialRows);

      test('Then it should clear the current selection and add the new rows',
          () {
        notifier.selectMany = <String>{'row3', 'row4'};
        expect(notifier.value, equals(<String>{'row3', 'row4'}));
      });
    });

    group('When reset is called', () {
      final initialRows = <String>{'row1', 'row2', 'row3'};
      final notifier = SelectedRowsNotifier<String>(rows: initialRows);

      test('Then it should clear all selected rows', () {
        notifier.reset();
        expect(notifier.value, isEmpty);
      });
    });

    group('When listeners are added', () {
      final notifier = SelectedRowsNotifier<String>(rows: <String>{});

      test('Then it should notify listeners on toggle', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..toggle = 'row1';

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on selectMany', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..selectMany = <String>{'row1', 'row2', 'row3'};

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
