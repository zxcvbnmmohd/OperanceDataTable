// lib/src/filter_dialog.dart

import 'package:flutter/material.dart';
import 'package:operance_datatable/src/filter.dart';
import 'package:operance_datatable/src/filter_widgets.dart'; // Ensure this exists

class FilterDialog extends StatelessWidget {
  final String columnName;
  final FilterType filterType;
  final Filter? currentFilter;
  final void Function(Filter) onApply;
  final List<String>? filterOptions;

  const FilterDialog({
    required this.columnName,
    required this.filterType,
    required this.onApply,
    this.currentFilter,
    this.filterOptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter $columnName'),
      content: _buildFilterWidget(),
    );
  }

  Widget _buildFilterWidget() {
    switch (filterType) {
      case FilterType.text:
        return TextFilterWidget(
          initialValue: currentFilter?.value as String?,
          initialOperator: currentFilter?.operator ?? 'contains',
          onApply: (operator, value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.text,
              value: value,
              operator: operator,
            );
            onApply(filter);
          },
          onClear: () => onApply(Filter.clear(columnName)), // Add this line
        );
      case FilterType.numeric:
        return NumericFilterWidget(
          initialValue: currentFilter?.value as num?,
          initialOperator: currentFilter?.operator ?? '>',
          onApply: (operator, value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.numeric,
              value: value,
              operator: operator,
            );
            onApply(filter);
          },
        );
      case FilterType.date:
        return DateFilterWidget(
          initialValue: currentFilter?.value as DateTime?,
          initialOperator: currentFilter?.operator ?? 'on',
          onApply: (operator, value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.date,
              value: value,
              operator: operator,
            );
            onApply(filter);
          },
        );
      case FilterType.boolean:
        return BooleanFilterWidget(
          initialValue: currentFilter?.value as bool?,
          onApply: (value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.boolean,
              value: value,
              operator: 'is',
            );
            onApply(filter);
          },
        );
      case FilterType.list:
        return ListFilterWidget(
          options: filterOptions ?? [],
          initialValues: currentFilter?.value as List<String>? ?? [],
          onApply: (values) {
            final filter = Filter(
              field: columnName,
              type: FilterType.list,
              value: values,
              operator: 'contains',
            );
            onApply(filter);
          },
        );
    }
  }
}
