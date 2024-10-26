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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildFilterWidget() {
    switch (filterType) {
      case FilterType.text:
        return TextFilterWidget(
          initialValue: currentFilter?.value as String?,
          initialOperator: currentFilter?.operator ?? 'contains',
          operators: const ['contains', 'equals', 'startsWith', 'endsWith'],
          onApply: (operator, value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.text,
              value: value,
              operator: operator,
            );
            onApply(filter);
          },
        );

      case FilterType.numeric:
        return NumericFilterWidget(
          initialValue: currentFilter?.value as num?,
          initialOperator: currentFilter?.operator ?? '=',
          operators: const ['=', '>', '>=', '<', '<=', '!='],
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

      case FilterType.boolean:
        return BooleanFilterWidget(
          initialValue: currentFilter?.value as bool?,
          onApply: (value) {
            final filter = Filter(
              field: columnName,
              type: FilterType.boolean,
              value: value,
              operator: 'equals',
            );
            onApply(filter);
          },
        );

      case FilterType.list:
        if (filterOptions == null) {
          return const Text('No options available');
        }
        return ListFilterWidget(
          options: filterOptions!,
          initialValues: currentFilter?.value as List<String>? ?? [],
          onApply: (values) {
            final filter = Filter(
              field: columnName,
              type: FilterType.list,
              value: values,
              operator: 'in',
            );
            onApply(filter);
          },
        );

      default:
        return const Text('Unsupported filter type');
    }
  }
}

// Filter Widgets
class TextFilterWidget extends StatefulWidget {
  final String? initialValue;
  final String? initialOperator;
  final List<String> operators;
  final void Function(String operator, String value) onApply;

  const TextFilterWidget({
    required this.operators,
    required this.onApply,
    this.initialValue,
    this.initialOperator,
    super.key,
  });

  @override
  State<TextFilterWidget> createState() => _TextFilterWidgetState();
}

class _TextFilterWidgetState extends State<TextFilterWidget> {
  late String _operator;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _operator = widget.initialOperator ?? widget.operators.first;
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: _operator,
          items: widget.operators
              .map((op) => DropdownMenuItem(value: op, child: Text(op)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _operator = value);
            }
          },
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Value'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_operator, _controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class NumericFilterWidget extends StatefulWidget {
  final num? initialValue;
  final String? initialOperator;
  final List<String> operators;
  final void Function(String operator, num value) onApply;

  const NumericFilterWidget({
    required this.operators,
    required this.onApply,
    this.initialValue,
    this.initialOperator,
    super.key,
  });

  @override
  State<NumericFilterWidget> createState() => _NumericFilterWidgetState();
}

class _NumericFilterWidgetState extends State<NumericFilterWidget> {
  late String _operator;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _operator = widget.initialOperator ?? widget.operators.first;
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: _operator,
          items: widget.operators
              .map((op) => DropdownMenuItem(value: op, child: Text(op)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _operator = value);
            }
          },
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Value'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_operator, num.parse(_controller.text));
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class BooleanFilterWidget extends StatefulWidget {
  final bool? initialValue;
  final void Function(bool value) onApply;

  const BooleanFilterWidget({
    required this.onApply,
    this.initialValue,
    super.key,
  });

  @override
  State<BooleanFilterWidget> createState() => _BooleanFilterWidgetState();
}

class _BooleanFilterWidgetState extends State<BooleanFilterWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Checkbox(
              value: _value,
              onChanged: (value) {
                setState(() => _value = value ?? false);
              },
            ),
            const Text('True'),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_value);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class ListFilterWidget extends StatefulWidget {
  final List<String> options;
  final List<String>? initialValues;
  final void Function(List<String> values) onApply;

  const ListFilterWidget({
    required this.options,
    required this.onApply,
    this.initialValues,
    super.key,
  });

  @override
  State<ListFilterWidget> createState() => _ListFilterWidgetState();
}

class _ListFilterWidgetState extends State<ListFilterWidget> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValues ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.options
              .map((option) => ChoiceChip(
                    label: Text(option),
                    selected: _selectedValues.contains(option),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedValues.add(option);
                        } else {
                          _selectedValues.remove(option);
                        }
                      });
                    },
                  ))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_selectedValues);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
