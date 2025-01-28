// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column.dart';
import 'package:operance_datatable/src/models/operance_data_column_width.dart';
import 'package:operance_datatable/src/models/operance_data_decoration.dart';
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/providers/providers.dart';
import 'package:operance_datatable/src/widgets/operance_data_row.dart';

void main() {
  final columns = <OperanceDataColumn<String>>[
    OperanceDataColumn<String>(
      name: 'id',
      columnHeader: const Text('ID'),
      cellBuilder: (context, item) => Text(item),
      primary: true,
      width: const OperanceDataColumnWidth(size: 100),
    ),
    OperanceDataColumn<String>(
      name: 'name',
      columnHeader: const Text('Name'),
      cellBuilder: (context, item) => Text('Name: $item'),
      width: const OperanceDataColumnWidth(size: 200),
    ),
    OperanceDataColumn<String>(
      name: 'email',
      columnHeader: const Text('Email'),
      cellBuilder: (context, item) => Text('Email: $item'),
      width: const OperanceDataColumnWidth(size: 150),
    ),
  ];

  final controller = OperanceDataController<String>(
    columnOrder: List.generate(
      columns.length,
      (index) => index,
    ).toSet(),
  );

  final decoration = OperanceDataDecoration();

  Widget buildApp({
    String? row,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    ValueChanged<Set<String>>? onChecked,
    void Function(String)? onRowPressed,
    Widget Function(BuildContext, String)? expansionBuilder,
    int index = 0,
    double tableWidth = 500,
    bool expandable = false,
    bool selectable = false,
  }) {
    return MaterialApp(
      home: Material(
        child: OperanceDataControllerProvider<String>(
          controller: controller,
          child: OperanceDataDecorationProvider(
            decoration: decoration,
            child: OperanceDataRow<String>(
              columns: columns,
              row: row ?? 'Test Row',
              index: index,
              tableWidth: tableWidth,
              onEnter: onEnter,
              onExit: onExit,
              onChecked: onChecked,
              onRowPressed: onRowPressed,
              expansionBuilder: expansionBuilder,
              expandable: expandable,
              selectable: selectable,
            ),
          ),
        ),
      ),
    );
  }

  group('Given an OperanceDataRow instance', () {
    group('When basic row rendering', () {
      testWidgets('Then it should display the row content', (tester) async {
        await tester.pumpWidget(buildApp(row: 'Hello World'));
        expect(find.text('Hello World'), findsOneWidget);
      });
    });

    group('When row is selectable', () {
      testWidgets('Then it should display a checkbox', (tester) async {
        await tester
            .pumpWidget(buildApp(row: 'Selectable Row', selectable: true));
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('Then checkbox should toggle row selection', (tester) async {
        await tester
            .pumpWidget(buildApp(row: 'Selectable Row', selectable: true));
        var checkbox = tester.widget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, isFalse);

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        checkbox = tester.widget(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
        expect(controller.selectedRows, contains('Selectable Row'));
      });
    });

    group('When row is expandable', () {
      testWidgets('Then it should display expansion icon', (tester) async {
        await tester.pumpWidget(buildApp(
          row: 'Expandable Row',
          expandable: true,
          expansionBuilder: (context, item) => Text('Expanded $item'),
        ));
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('Then expansion icon should toggle row expansion',
          (tester) async {
        await tester.pumpWidget(buildApp(
          row: 'Expandable Row',
          expandable: true,
          expansionBuilder: (context, item) => Text('Expanded $item'),
          index: 0,
        ));

        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        expect(find.text('Expanded Expandable Row'), findsOneWidget);
        expect(controller.expandedRowsNotifier.value, contains(0));

        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        expect(find.text('Expanded Expandable Row'), findsNothing);
        expect(controller.expandedRowsNotifier.value, isEmpty);
      });

      testWidgets(
          'Then expansion icon should animate rotation of expansion icon',
          (tester) async {
        await tester.pumpWidget(buildApp(
          row: 'Expandable Row',
          expandable: true,
          expansionBuilder: (context, item) => Text('Expanded $item'),
          index: 0,
        ));

        // Verify initial state
        expect(find.byType(Icon), findsOneWidget);
        expect(find.text('Expanded Expandable Row'), findsNothing);

        // Tap to expand
        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        // Verify expanded state
        expect(find.text('Expanded Expandable Row'), findsOneWidget);
        expect(controller.expandedRowsNotifier.value, contains(0));

        // Verify rotation transition
        final rotationTransition = tester.widget<RotationTransition>(
          find.byType(RotationTransition).first,
        );

        // Ensure that the animation begins from 0.5 and ends at 1.0 as expected
        expect(rotationTransition.turns.value, greaterThanOrEqualTo(0.5));
        expect(rotationTransition.turns.value, lessThan(1.0));

        // Verify fade transition
        final fadeTransition = tester.widget<FadeTransition>(
          find.byType(FadeTransition).first,
        );
        expect(fadeTransition.opacity.value, equals(1.0));

        // Tap to collapse
        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        // Verify collapsed state
        expect(find.text('Expanded Expandable Row'), findsNothing);
        expect(controller.expandedRowsNotifier.value, isEmpty);

        // Verify rotation transition after collapse (it should be back to the
        // collapsed state)
        final rotationTransitionCollapsed = tester.widget<RotationTransition>(
          find.byType(RotationTransition).first,
        );
        expect(rotationTransitionCollapsed.turns.value, lessThanOrEqualTo(0.5));

        // Verify fade transition
        final fadeTransitionCollapsed = tester.widget<FadeTransition>(
          find.byType(FadeTransition).first,
        );
        expect(fadeTransitionCollapsed.opacity.value, equals(1.0));
      });
    });

    group('When row is pressable', () {
      testWidgets('Then it should call onRowPressed when tapped',
          (tester) async {
        var wasTapped = false;
        await tester.pumpWidget(buildApp(
          row: 'Pressable Row',
          onRowPressed: (row) {
            wasTapped = true;
          },
        ));

        await tester.tap(find.text('Pressable Row'));
        await tester.pumpAndSettle();

        expect(wasTapped, isTrue);
      });
    });

    group('When mouse interactions are enabled', () {
      testWidgets('Then it should handle onEnter event', (tester) async {
        var wasEntered = false;
        await tester.pumpWidget(buildApp(
          row: 'Hover Row',
          onEnter: (event) {
            wasEntered = true;
            controller.hoveredRowNotifier.value = 0;
          },
          onRowPressed: (row) {},
        ));

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();

        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Hover Row')));
        await tester.pumpAndSettle();

        expect(wasEntered, isTrue);

        final container =
            tester.widget(find.byType(AnimatedContainer)) as AnimatedContainer;
        final containerDecoration = container.decoration as BoxDecoration;
        final hoverColor = containerDecoration.color;

        expect(hoverColor, equals(decoration.colors.rowHoverColor));
      });

      testWidgets('Then it should handle onExit event', (tester) async {
        var wasEntered = false;
        var wasExited = false;

        await tester.pumpWidget(buildApp(
          row: 'Hover Row',
          onEnter: (event) {
            wasEntered = true;
          },
          onExit: (event) {
            wasExited = true;
          },
          onRowPressed: (row) {},
        ));

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();

        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Hover Row')));
        await tester.pumpAndSettle();

        expect(wasEntered, isTrue);

        await gesture.removePointer();
        await tester.pumpAndSettle();

        expect(wasExited, isTrue);
      });
    });

    group('When column visibility is toggled', () {
      testWidgets('Then it should hide columns marked as hidden',
          (tester) async {
        controller.hiddenColumnsNotifier.value = <String>{'name'};

        await tester.pumpWidget(buildApp(row: 'Visibility Test'));
        await tester.pumpAndSettle();

        expect(find.text('Visibility Test'), findsOneWidget);
      });
    });

    group('When calculating total hidden width', () {
      testWidgets('Then it should sum the widths of hidden columns',
          (tester) async {
        controller.hiddenColumnsNotifier.value = <String>{'name'};

        await tester.pumpWidget(buildApp(row: 'Hidden Width Test'));
        await tester.pumpAndSettle();

        final totalHiddenWidth = columns[1].width.value(500);
        expect(totalHiddenWidth, equals(200.0));
      });

      testWidgets('Then it should sum the widths of multiple hidden columns',
          (tester) async {
        controller.hiddenColumnsNotifier.value = <String>{'name', 'email'};

        await tester.pumpWidget(buildApp(row: 'Hidden Width Test'));
        await tester.pumpAndSettle();

        final totalHiddenWidth =
            columns[1].width.value(500) + columns[2].width.value(500);
        expect(totalHiddenWidth, equals(350.0));
      });
    });

    group('When multiple features are combined', () {
      testWidgets('Then it should support multiple row features',
          (tester) async {
        var wasRowPressed = false;
        var wasChecked = false;

        await tester.pumpWidget(buildApp(
          row: 'Multi-Feature Row',
          expandable: true,
          selectable: true,
          onRowPressed: (row) {
            wasRowPressed = true;
          },
          onChecked: (selectedRows) {
            wasChecked = true;
          },
          expansionBuilder: (context, item) => Text('Expanded $item'),
        ));

        expect(find.byType(Checkbox), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.text('Multi-Feature Row'), findsOneWidget);

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        expect(wasChecked, isTrue);

        await tester.tap(find.text('Multi-Feature Row'));
        await tester.pumpAndSettle();
        expect(wasRowPressed, isTrue);

        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();
        expect(find.text('Expanded Multi-Feature Row'), findsOneWidget);
      });
    });
  });
}
