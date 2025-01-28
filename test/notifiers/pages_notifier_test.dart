// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/pages_notifier.dart';

void main() {
  group('Given an instance of PagesNotifier', () {
    group('When created with default parameters', () {
      final notifier = PagesNotifier<String>(
        pages: <Set<String>>{},
        rowsPerPage: 25,
      );

      test('Then it should initialize with an empty set of pages', () {
        expect(notifier.value, equals(<Set<String>>{}));
      });

      test('Then it should initialize with an empty set of rows', () {
        expect(notifier.rows, equals(<Set<String>>{}));
      });

      test('Then it should have a default rowsPerPage value of 25', () {
        expect(notifier.rowsPerPage, equals(25));
      });
    });

    group('When created with specific pages and rowsPerPage', () {
      final initialPages = <Set<String>>{
        <String>{'row1', 'row2'},
        <String>{'row3', 'row4'},
      };
      final notifier = PagesNotifier<String>(
        pages: initialPages,
        rowsPerPage: 10,
      );

      test('Then it should initialize with the provided set of pages', () {
        expect(notifier.value, equals(initialPages));
      });

      test('Then it should initialize with the provided rowsPerPage value', () {
        expect(notifier.rowsPerPage, equals(10));
      });
    });

    group('When add is called with a single row', () {
      final notifier = PagesNotifier<String>(
        pages: <Set<String>>{},
        rowsPerPage: 2,
      );

      test('Then it should add the row to a new page', () {
        notifier.add = <String>{'row1'};

        expect(
            notifier.value,
            equals(<Set<String>>{
              {'row1'}
            }));
      });
    });

    group('When addAll is called with a list of rows', () {
      final notifier = PagesNotifier<String>(
        pages: <Set<String>>{},
        rowsPerPage: 2,
      );

      test('Then it should add rows to pages based on rowsPerPage', () {
        notifier.addAll = <String>{'row1', 'row2', 'row3', 'row4'};
        expect(
          notifier.value,
          equals(<Set<String>>{
            {'row1', 'row2'},
            {'row3', 'row4'},
          }),
        );
      });

      test('Then it should handle rows that do not fill a complete page', () {
        notifier.addAll = <String>{'row1', 'row2', 'row3'};
        expect(
          notifier.value,
          equals(<Set<String>>{
            {'row1', 'row2'},
            {'row3'},
          }),
        );
      });
    });

    group('When updateRow is called', () {
      final initialPages = <Set<String>>{
        {'row1', 'row2'},
        {'row3', 'row4'},
      };
      final notifier = PagesNotifier<String>(pages: initialPages);

      test('Then it should update the row in the correct page', () {
        notifier.updateRow('row2', 'row2_updated');
        expect(
          notifier.value,
          equals(<Set<String>>{
            {'row1', 'row2_updated'},
            {'row3', 'row4'},
          }),
        );

        notifier.updateRow('row3', 'row3_updated');
        expect(
          notifier.value,
          equals(<Set<String>>{
            {'row1', 'row2_updated'},
            {'row3_updated', 'row4'},
          }),
        );
      });

      test('Then it should handle updating a row that does not exist', () {
        notifier.updateRow('row5', 'row5_updated');
        expect(
          notifier.value,
          equals(<Set<String>>{
            {'row1', 'row2_updated'},
            {'row3_updated', 'row4'},
          }),
        );
      });
    });

    group('When reset is called', () {
      final initialPages = <Set<String>>{
        <String>{'row1', 'row2'},
        <String>{'row3', 'row4'},
      };
      final notifier = PagesNotifier<String>(pages: initialPages);

      test('Then it should clear all pages and add an empty page', () {
        notifier.reset();
        expect(notifier.value, equals(<Set<String>>{{}}));
      });
    });

    group('When listeners are added', () {
      final notifier = PagesNotifier<String>(
        pages: <Set<String>>{},
        rowsPerPage: 25,
      );

      test('Then it should notify listeners on add', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..add = <String>{'row1'};

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on addAll', () {
        var notifyCalled = false;

        notifier
          ..addListener(() {
            notifyCalled = true;
          })
          ..addAll = <String>{'row1', 'row2', 'row3', 'row4'};

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on updateRow', () {
        var notifyCalled = false;

        notifier
          ..addAll = <String>{'row1', 'row2'}
          ..addListener(() {
            notifyCalled = true;
          })
          ..updateRow('row2', 'row2_updated');

        expect(notifyCalled, isTrue);
      });

      test('Then it should notify listeners on reset', () {
        var notifyCalled = false;

        notifier
          ..addAll = <String>{'row1', 'row2'}
          ..addListener(() {
            notifyCalled = true;
          })
          ..reset();

        expect(notifyCalled, isTrue);
      });
    });
  });
}
