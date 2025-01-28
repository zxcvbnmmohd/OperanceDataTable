// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_decoration.dart';
import 'package:operance_datatable/src/providers/operance_data_decoration_provider.dart';

// 🌎 Project imports:

void main() {
  group('Given an instance of OperanceDataDecorationProvider', () {
    group('When created with a specific decoration', () {
      final decoration = OperanceDataDecoration();
      final provider = OperanceDataDecorationProvider(
        decoration: decoration,
        child: Container(),
      );

      test('Then it should hold the provided decoration', () {
        expect(provider.decoration, equals(decoration));
      });
    });

    group('When of is called with a valid context', () {
      final decoration = OperanceDataDecoration();
      final provider = OperanceDataDecorationProvider(
        decoration: decoration,
        child: Container(),
      );

      testWidgets('Then it should return the provided decoration',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = OperanceDataDecorationProvider.of(
            tester.element(find.byType(Container)));
        expect(foundController, equals(decoration));
      });
    });

    group('When of is called with an invalid context', () {
      testWidgets('Then it should throw an assertion error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
          ),
        );

        expect(
          () {
            OperanceDataDecorationProvider.of(
                tester.element(find.byType(Container)));
          },
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('When updateShouldNotify is called', () {
      final decoration1 = OperanceDataDecoration();
      final decoration2 = OperanceDataDecoration();
      final provider1 = OperanceDataDecorationProvider(
        decoration: decoration1,
        child: Container(),
      );
      final provider2 = OperanceDataDecorationProvider(
        decoration: decoration2,
        child: Container(),
      );

      test('Then it should return true if the controllers are different', () {
        expect(provider1.updateShouldNotify(provider2), isTrue);
      });

      test('Then it should return false if the controllers are the same', () {
        expect(provider1.updateShouldNotify(provider1), isFalse);
      });
    });

    group('When used in a widget tree', () {
      final decoration = OperanceDataDecoration();
      final provider = OperanceDataDecorationProvider(
        decoration: decoration,
        child: Container(),
      );

      testWidgets(
          'Then it should notify dependents when the decoration changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = OperanceDataDecorationProvider.of(
            tester.element(find.byType(Container)));
        expect(foundController, equals(decoration));

        final newController = OperanceDataDecoration();
        final newProvider = OperanceDataDecorationProvider(
          decoration: newController,
          child: Container(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: newProvider,
          ),
        );

        final newFoundController = OperanceDataDecorationProvider.of(
            tester.element(find.byType(Container)));
        expect(newFoundController, equals(newController));
      });
    });
  });
}
