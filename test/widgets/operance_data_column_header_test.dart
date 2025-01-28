// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_column.dart';
import 'package:operance_datatable/src/models/operance_data_decoration.dart';
import 'package:operance_datatable/src/notifiers/operance_data_controller.dart';
import 'package:operance_datatable/src/providers/providers.dart';
import 'package:operance_datatable/src/values/values.dart';
import 'package:operance_datatable/src/widgets/operance_data_column_header.dart';

void main() {
  group('Given an instance of OperanceDataColumnHeader', () {
    final columns = <OperanceDataColumn<String>>[
      OperanceDataColumn<String>(
        name: 'id',
        columnHeader: const Text('ID'),
        cellBuilder: (context, item) => Text(item),
        primary: true,
        sortable: true,
      ),
      OperanceDataColumn<String>(
        name: 'name',
        columnHeader: const Text('Name'),
        cellBuilder: (context, item) => Text(item),
        primary: false,
        sortable: true,
      ),
      OperanceDataColumn<String>(
        name: 'age',
        columnHeader: const Text('Age'),
        cellBuilder: (context, item) => Text(item),
        primary: false,
        sortable: true,
      ),
      OperanceDataColumn<String>(
        name: 'email',
        columnHeader: const Text('Email'),
        cellBuilder: (context, item) => Text(item),
        primary: false,
        sortable: true,
      ),
    ];

    final controller = OperanceDataController<String>(
      columnOrder: List.generate(
        columns.length,
        (index) => index,
      ).toSet(),
      hiddenColumns: <String>{'email'},
      initialPage: (<String>['row1', 'row2', 'row3'], true),
    );

    final decoration = OperanceDataDecoration(
      icons: OperanceDataIcons(
        hiddenColumnsDropdownClearIcon: Icons.clear,
      ),
      sizes: OperanceDataSizes(
        columnHeaderHeight: 50.0,
        hiddenColumnsDropdownWidth: 250.0,
      ),
      styles: OperanceDataStyles(
        columnHeaderDecoration: BoxDecoration(
          color: Colors.grey[200],
        ),
      ),
    );

    Widget buildApp({
      OperanceDataController<String>? controller,
      OperanceDataDecoration? decoration,
      List<Widget> trailing = const <Widget>[],
      bool allowColumnReorder = false,
      bool expandable = false,
      bool selectable = false,
    }) {
      return MaterialApp(
        home: Material(
          child: OperanceDataControllerProvider<String>(
            controller: controller ?? OperanceDataController<String>(),
            child: OperanceDataDecorationProvider(
              decoration: decoration ?? OperanceDataDecoration(),
              child: OperanceDataColumnHeader<String>(
                columns: columns,
                tableWidth: 800.0,
                trailing: trailing,
                allowColumnReorder: allowColumnReorder,
                expandable: expandable,
                selectable: selectable,
              ),
            ),
          ),
        ),
      );
    }

    group('When built with a specific set of columns', () {
      testWidgets('Then it should display the columns in the correct order',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        await tester.pumpAndSettle();

        expect(find.text('ID'), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Age'), findsOneWidget);

        final idFinder = find.text('ID').hitTestable();
        final nameFinder = find.text('Name').hitTestable();
        final ageFinder = find.text('Age').hitTestable();

        final idOffset = tester.getCenter(idFinder);
        final nameOffset = tester.getCenter(nameFinder);
        final ageOffset = tester.getCenter(ageFinder);

        expect(idOffset.dx < nameOffset.dx, isTrue);
        expect(nameOffset.dx < ageOffset.dx, isTrue);
      });
    });

    group('When column reordering is allowed', () {
      testWidgets('Then it should allow reordering of columns', (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
          allowColumnReorder: true,
        ));

        await tester.pumpAndSettle();

        final nameFinder = find.text('Name').hitTestable();
        final ageFinder = find.text('Age').hitTestable();

        final nameOffset = tester.getCenter(nameFinder);
        final ageOffset = tester.getCenter(ageFinder);

        // Drag 'Name' to the position of 'Age'
        await tester.dragFrom(nameOffset, ageOffset - nameOffset);
        await tester.pumpAndSettle();

        // Verify the order has changed
        final idFinderReordered = find.text('ID').hitTestable();
        final ageFinderReordered = find.text('Age').hitTestable();
        final nameFinderReordered = find.text('Name').hitTestable();

        final idOffsetReordered = tester.getCenter(idFinderReordered);
        final ageOffsetReordered = tester.getCenter(ageFinderReordered);
        final nameOffsetReordered = tester.getCenter(nameFinderReordered);

        expect(idOffsetReordered.dx < ageOffsetReordered.dx, isTrue);
        expect(ageOffsetReordered.dx < nameOffsetReordered.dx, isTrue);
      });
    });

    group('When the selectable checkbox is present', () {
      testWidgets('Then it should display the selectable checkbox',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
          selectable: true,
        ));

        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('Then it should toggle selection of all rows',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
          selectable: true,
        ));

        // Ensure the checkbox is not checked
        expect(find.byType(Checkbox), findsOneWidget);
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Verify all rows are selected
        expect(
          controller.selectedRowsNotifier.value.length,
          equals(3),
        );

        // Uncheck the checkbox
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Verify no rows are selected
        expect(controller.selectedRowsNotifier.value.isEmpty, isTrue);
      });
    });

    group('When the expandable option is enabled', () {
      testWidgets('Then it should display the expandable container',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
          expandable: true,
        ));

        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Container).at(0), findsOneWidget);
        expect(find.byType(Container).at(0).hitTestable(), findsOneWidget);
      });
    });

    group('When trailing widgets are provided', () {
      testWidgets('Then it should display the trailing widgets',
          (tester) async {
        final trailingWidgets = [
          const Icon(Icons.search),
          const Icon(Icons.filter),
        ];

        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
          trailing: trailingWidgets,
        ));

        expect(find.byType(Icon), findsWidgets);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.filter), findsOneWidget);
      });
    });

    group('When built with sortable columns', () {
      testWidgets('Then it should display the sort icon for sortable columns',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));

        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('sort_id')), findsOneWidget);
        expect(find.byKey(ValueKey('sort_name')), findsOneWidget);
        expect(find.byKey(ValueKey('sort_age')), findsOneWidget);
      });

      testWidgets('Then it should toggle the sort direction on tap',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          decoration: decoration,
        ));
        await tester.pumpAndSettle();

        final sortIcon = find.byKey(ValueKey('sort_id'));
        await tester.tap(sortIcon);
        await tester.pumpAndSettle();

        expect(controller.sortsNotifier.value['id'], SortDirection.ascending);

        // Tap again to toggle
        await tester.tap(sortIcon);
        await tester.pumpAndSettle();

        expect(controller.sortsNotifier.value['id'], SortDirection.descending);
      });
    });
  });
}
