// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/extensions/extensions.dart';
import 'package:operance_datatable/src/models/operance_data_column.dart';

/// A widget that displays a dropdown button for hiding columns.
class OperanceDataColumnDropdown<T> extends StatelessWidget {
  /// Creates a new [OperanceDataColumnDropdown] instance.
  ///
  /// The [columns] argument is required.
  const OperanceDataColumnDropdown({
    required this.columns,
    super.key,
  });

  /// The list of columns to be displayed in the table.
  final List<OperanceDataColumn<T>> columns;

  @override
  Widget build(BuildContext context) {
    final controller = context.controller<T>();
    final decoration = context.decoration();
    final icons = decoration.icons;
    final sizes = decoration.sizes;
    final styles = decoration.styles;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: sizes.hiddenColumnsDropdownWidth,
      ),
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: controller.hiddenColumnsNotifier,
        builder: (context, hiddenColumns, _) {
          final decoration = styles.hiddenColumnsDropdownDecoration;
          final nonPrimaryColumns = columns.where((column) {
            return !column.primary;
          }).toList();

          return DropdownButtonFormField<String>(
            decoration: decoration.copyWith(
              suffixIcon: hiddenColumns.isNotEmpty
                  ? IconButton(
                      icon: Icon(icons.hiddenColumnsDropdownClearIcon),
                      onPressed: controller.resetHiddenColumns,
                    )
                  : null,
            ),
            items: List<DropdownMenuItem<String>>.generate(
              nonPrimaryColumns.length,
              (index) {
                final name = nonPrimaryColumns[index].name;

                return DropdownMenuItem<String>(
                  value: name,
                  child: Row(
                    key: Key('checkbox_$name'),
                    children: <Widget>[
                      Checkbox(
                        value: !hiddenColumns.contains(name),
                        onChanged: (value) {
                          if (value != null) {
                            controller.toggleHideColumn = name;
                          }
                        },
                      ),
                      Expanded(
                        child: nonPrimaryColumns[index].columnHeader,
                      ),
                    ],
                  ),
                );
              },
            ),
            selectedItemBuilder: (context) {
              return nonPrimaryColumns.map((_) {
                return decoration.label ?? Text(decoration.labelText!);
              }).toList();
            },
            onChanged: (column) {
              if (column != null) {
                controller.toggleHideColumn = column;
              }
            },
          );
        },
      ),
    );
  }
}
