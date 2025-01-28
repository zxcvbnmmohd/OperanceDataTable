// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/providers/operance_data_controller_provider.dart';

void main() {
  group('Given an instance of OperanceDataControllerProvider', () {
    group('When created with a specific controller', () {
      final controller = OperanceDataController<String>();
      final provider = OperanceDataControllerProvider<String>(
        controller: controller,
        child: Container(),
      );

      test('Then it should hold the provided controller', () {
        expect(provider.controller, equals(controller));
      });
    });

    group('When of is called with a valid context', () {
      final controller = OperanceDataController<String>();
      final provider = OperanceDataControllerProvider<String>(
        controller: controller,
        child: Container(),
      );

      testWidgets('Then it should return the provided controller',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = OperanceDataControllerProvider.of<String>(
            tester.element(find.byType(Container)));
        expect(foundController, equals(controller));
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
            OperanceDataControllerProvider.of<String>(
                tester.element(find.byType(Container)));
          },
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('When updateShouldNotify is called', () {
      final controller1 = OperanceDataController<String>();
      final controller2 = OperanceDataController<String>();
      final provider1 = OperanceDataControllerProvider<String>(
        controller: controller1,
        child: Container(),
      );
      final provider2 = OperanceDataControllerProvider<String>(
        controller: controller2,
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
      final controller = OperanceDataController<String>();
      final provider = OperanceDataControllerProvider<String>(
        controller: controller,
        child: Container(),
      );

      testWidgets(
          'Then it should notify dependents when the controller changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = OperanceDataControllerProvider.of<String>(
            tester.element(find.byType(Container)));
        expect(foundController, equals(controller));

        final newController = OperanceDataController<String>();
        final newProvider = OperanceDataControllerProvider<String>(
          controller: newController,
          child: Container(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: newProvider,
          ),
        );

        final newFoundController = OperanceDataControllerProvider.of<String>(
            tester.element(find.byType(Container)));
        expect(newFoundController, equals(newController));
      });
    });
  });
}
