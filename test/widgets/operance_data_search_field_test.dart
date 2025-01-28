// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_decoration.dart';
import 'package:operance_datatable/src/providers/operance_data_decoration_provider.dart';
import 'package:operance_datatable/src/widgets/operance_data_search_field.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  final decoration = OperanceDataDecoration();

  Widget buildApp({
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String?>? onChanged,
  }) {
    return MaterialApp(
      home: Material(
        child: OperanceDataDecorationProvider(
          decoration: decoration,
          child: OperanceDataSearchField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  group('Given an OperanceDataSearchField widget', () {
    group('When rendering the widget', () {
      testWidgets('Then it should use the provided controller and focusNode',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
        ));

        final textField = tester.widget<TextField>(find.byType(TextField));

        expect(textField.controller, controller);
        expect(textField.focusNode, focusNode);
      });

      testWidgets('Then it should apply maxWidth constraint from decoration',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
        ));

        final constrainedBox = tester.widget<ConstrainedBox>(
          find
              .descendant(
                of: find.byType(OperanceDataSearchField),
                matching: find.byType(ConstrainedBox),
              )
              .first,
        );
        final constraints = constrainedBox.constraints;

        expect(constraints.maxWidth, decoration.sizes.searchWidth);
      });
    });

    group('When the controller has initial text', () {
      testWidgets('Then it should display the initial text in the search field',
          (tester) async {
        const initialText = 'Initial search term';
        controller.text = initialText;

        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
        ));

        final textField = tester.widget<TextField>(find.byType(TextField));

        expect(textField.controller?.text, initialText);
      });
    });

    group('When the search field value changes', () {
      testWidgets('Then it should call onChanged callback with the new value',
          (tester) async {
        String? searchText;
        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) {
            searchText = value;
          },
        ));

        await tester.enterText(find.byType(TextField), 'search term');
        await tester.pump();

        expect(searchText, 'search term');
      });

      testWidgets('Then it should not call onChanged when not provided',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
        ));

        await tester.enterText(find.byType(TextField), 'search term');
        await tester.pump();

        expect(controller.text, 'search term');
      });
    });

    group('When focus node is attached', () {
      testWidgets(
          'Then it should correctly attach the focus node to the TextField',
          (tester) async {
        await tester.pumpWidget(buildApp(
          controller: controller,
          focusNode: focusNode,
        ));

        final textField = tester.widget<TextField>(find.byType(TextField));

        expect(textField.focusNode, focusNode);
      });
    });
  });
}
