// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/providers/operance_data_controller_provider.dart';

void main() {
  group('Given an OperanceDataControllerProvider instance', () {
    late OperanceDataController<int> controller1;
    late OperanceDataController<int> controller2;
    late OperanceDataControllerProvider<int> provider1;
    late OperanceDataControllerProvider<int> provider2;

    setUp(() {
      controller1 = OperanceDataController<int>();
      controller2 = OperanceDataController<int>();
      provider1 = OperanceDataControllerProvider<int>(
        controller: controller1,
        child: Container(),
      );
      provider2 = OperanceDataControllerProvider<int>(
        controller: controller2,
        child: Container(),
      );
    });

    group('When controllers are different', () {
      test('Then updateShouldNotify returns true', () {
        expect(provider1.updateShouldNotify(provider2), isTrue);
      });
    });

    group('When controllers are the same', () {
      setUp(() {
        provider2 = OperanceDataControllerProvider<int>(
          controller: controller1,
          child: Container(),
        );
      });

      test('Then updateShouldNotify returns false', () {
        expect(provider1.updateShouldNotify(provider2), isFalse);
      });
    });

    group('When accessing the controller via context', () {
      testWidgets('Then it should return the correct controller',
          (tester) async {
        final widget = MaterialApp(
          home: OperanceDataControllerProvider<int>(
            controller: controller1,
            child: Builder(
              builder: (context) {
                final controller =
                    OperanceDataControllerProvider.of<int>(context);
                expect(controller, equals(controller1));

                return Container();
              },
            ),
          ),
        );

        await tester.pumpWidget(widget);
      });
    });

    group('When creating an instance', () {
      test('Then it should initialize with the provided controller and child',
          () {
        final provider = OperanceDataControllerProvider<int>(
          controller: controller1,
          child: Container(),
        );

        expect(provider.controller, controller1);
        expect(provider.child, isA<Container>());
      });
    });

    group(
        'When the controller changes between the old and new '
        'OperanceDataControllerProvider instances', () {
      test('Then updateShouldNotify should return true', () {
        // Given
        final provider1 = OperanceDataControllerProvider<int>(
          controller: controller1,
          child: Container(),
        );
        final provider2 = OperanceDataControllerProvider<int>(
          controller: controller2,
          child: Container(),
        );

        // When
        final shouldNotify = provider1.updateShouldNotify(provider2);

        // Then
        expect(shouldNotify, isTrue);
      });
    });
  });
}
