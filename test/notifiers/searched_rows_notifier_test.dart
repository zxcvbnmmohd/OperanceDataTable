// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/searched_rows_notifier.dart';

void main() {
  group('Given an instance of SearchedRowsNotifier', () {
    group('When created with default parameters', () {
      final notifier = SearchedRowsNotifier<String>(rows: <String>{});

      test('Then it should initialize with an empty set and false', () {
        expect(notifier.value.$1, equals(<String>{}));
        expect(notifier.value.$2, isFalse);
      });
    });

    group('When toggleSearchMode is called', () {
      final notifier = SearchedRowsNotifier<String>();

      test('Then it should set searching to true', () {
        notifier.toggleSearchMode(searching: true);
        expect(notifier.value.$1, equals(<String>{}));
        expect(notifier.value.$2, isTrue);
      });

      test('Then it should set searching to false', () {
        notifier.toggleSearchMode(searching: false);
        expect(notifier.value.$1, equals(<String>{}));
        expect(notifier.value.$2, isFalse);
      });
    });

    group('When addRows is called', () {
      final notifier = SearchedRowsNotifier<String>();

      test('Then it should add the rows and set searching to true', () {
        final rows = <String>{'row1', 'row2'};
        notifier.addRows = rows;

        expect(notifier.value.$1, equals(rows));
        expect(notifier.value.$2, isTrue);
      });
    });

    group('When reset is called', () {
      final notifier = SearchedRowsNotifier<String>(rows: {'row1', 'row2'});

      test('Then it should clear all rows and set searching to false', () {
        notifier.reset();
        expect(notifier.value.$1, equals(<String>{}));
        expect(notifier.value.$2, isFalse);
      });
    });

    group('When listeners are added', () {
      final notifier = SearchedRowsNotifier<String>();

      test('Then it should notify listeners on addRows', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..addRows = <String>{'row1', 'row2'};

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on toggleSearchMode', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..toggleSearchMode(searching: true);

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
