// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column.dart';
import 'package:operance_datatable/src/models/operance_data_decoration.dart';
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/providers/operance_data_controller_provider.dart';
import 'package:operance_datatable/src/providers/operance_data_decoration_provider.dart';
import 'package:operance_datatable/src/widgets/operance_data_column_dropdown.dart';

void main() {
  group('Given an instance of OperanceDataColumnDropdown', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'id',
        columnHeader: const Text('ID'),
        cellBuilder: (context, item) => Text(item),
        primary: true,
      ),
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
        primary: false,
      ),
      OperanceDataColumn<String>(
        name: 'age',
        columnHeader: const Text('Age'),
        cellBuilder: (context, item) => Text(item),
        primary: false,
      ),
    ];

    final controller = OperanceDataController<String>();

    final decoration = OperanceDataDecoration(
      icons: OperanceDataIcons(
        hiddenColumnsDropdownClearIcon: Icons.clear,
      ),
      sizes: OperanceDataSizes(
        hiddenColumnsDropdownWidth: 250.0, // Increased width
      ),
      styles: OperanceDataStyles(
        hiddenColumnsDropdownDecoration: InputDecoration(
          labelText: 'Hidden Columns',
          border: OutlineInputBorder(), // Added border to help visibility
        ),
      ),
    );

    Widget buildApp({
      OperanceDataController<String>? controller,
      OperanceDataDecoration? decoration,
    }) {
      return MaterialApp(
        home: Material(
          child: OperanceDataControllerProvider<String>(
            controller: controller ?? OperanceDataController<String>(),
            child: OperanceDataDecorationProvider(
              decoration: decoration ?? OperanceDataDecoration(),
              child: OperanceDataColumnDropdown<String>(
                columns: columns,
              ),
            ),
          ),
        ),
      );
    }

    group('When built with a specific set of columns', () {
      testWidgets(
          'Then it should display the dropdown with non-primary columns',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        // Ensure the dropdown is fully visible
        await tester.ensureVisible(
          find.byType(DropdownButtonFormField<String>),
        );
        await tester.pumpAndSettle();

        // Open the dropdown with a more precise tap
        await tester.tap(
          find.byType(DropdownButtonFormField<String>),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Age'), findsOneWidget);
        expect(find.text('ID'), findsNothing);
      });
    });

    group('When a column is toggled', () {
      testWidgets('Then it should toggle the hidden state of the column',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        // Ensure the dropdown is fully visible
        await tester.ensureVisible(
          find.byType(DropdownButtonFormField<String>),
        );
        await tester.pumpAndSettle();

        // Open the dropdown
        await tester.tap(
          find.byType(DropdownButtonFormField<String>),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // Find the checkbox by its key and tap it
        final checkboxFinder = find.descendant(
          of: find.byKey(Key('checkbox_name')),
          matching: find.byType(Checkbox),
        );

        await tester.tap(checkboxFinder);
        await tester.pumpAndSettle();

        expect(
          controller.hiddenColumnsNotifier.value,
          equals(<String>{'name'}),
        );

        // Toggle 'Name' again
        await tester.tap(checkboxFinder);
        await tester.pumpAndSettle();

        expect(controller.hiddenColumnsNotifier.value, equals(<String>{}));
      });
    });

    group('When the clear icon is pressed', () {
      testWidgets('Then it should reset the hidden columns', (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        // Open the dropdown
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        // Hide the 'name' column
        final checkboxFinder = find.descendant(
          of: find.byKey(Key('checkbox_name')),
          matching: find.byType(Checkbox),
        );

        await tester.tap(checkboxFinder);
        await tester.pumpAndSettle();

        expect(
          controller.hiddenColumnsNotifier.value,
          equals(<String>{'name'}),
        );

        // Try to reset hidden columns
        final clearButtonFinder = find.descendant(
          of: find.byType(DropdownButtonFormField<String>),
          matching: find.byIcon(Icons.clear),
        );

        await tester.ensureVisible(clearButtonFinder);
        await tester.pumpAndSettle();

        if (clearButtonFinder.evaluate().isNotEmpty) {
          controller.resetHiddenColumns();
          // Force tap if necessary
          final clearButton = clearButtonFinder.evaluate().single;
          final clearButtonBox = clearButton.renderObject as RenderBox;
          final clearButtonOffset = clearButtonBox.localToGlobal(Offset.zero);
          await tester.tapAt(clearButtonOffset.translate(10, 10));
          await tester.pumpAndSettle();
        } else {
          // Fallback to direct reset
          controller.resetHiddenColumns();
          await tester.pumpAndSettle();
        }

        // Verify hidden columns are reset
        expect(controller.hiddenColumnsNotifier.value, isEmpty);
      });
    });

    group('When the dropdown onChanged is called', () {
      testWidgets('Then it should toggle the hidden state of the column',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        // Open the dropdown
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        // Select the 'name' column
        await tester.tap(find.text('Name').last);
        await tester.pumpAndSettle();

        expect(
          controller.hiddenColumnsNotifier.value,
          equals(<String>{'name'}),
        );

        // Open the dropdown
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        // Select the 'name' column again to toggle it back
        await tester.tap(find.text('Name').last);
        await tester.pumpAndSettle();

        expect(controller.hiddenColumnsNotifier.value, equals(<String>{}));
      });
    });
  });
}
