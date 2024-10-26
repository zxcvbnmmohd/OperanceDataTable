import 'package:flutter/material.dart';

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
  _TextFilterWidgetState createState() => _TextFilterWidgetState();
}

class _TextFilterWidgetState extends State<TextFilterWidget> {
  late String _selectedOperator;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.initialOperator ?? widget.operators.first;
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          decoration: const InputDecoration(labelText: 'Operator'),
          items: widget.operators
              .map((op) => DropdownMenuItem(value: op, child: Text(op)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedOperator = value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedOperator, _controller.text);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NumericFilterWidget extends StatefulWidget {
  final num? initialValue;
  final String initialOperator;
  final void Function(String operator, num value) onApply;

  const NumericFilterWidget({
    required this.initialOperator,
    required this.onApply,
    super.key,
    this.initialValue,
  });

  @override
  NumericFilterWidgetState createState() => NumericFilterWidgetState();
}

class NumericFilterWidgetState extends State<NumericFilterWidget> {
  late String _selectedOperator;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.initialOperator;
    _controller = TextEditingController(
        text:
            widget.initialValue != null ? widget.initialValue.toString() : '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          decoration: const InputDecoration(labelText: 'Operator'),
          items: const [
            DropdownMenuItem(value: '=', child: Text('Equals')),
            DropdownMenuItem(value: '>', child: Text('Greater Than')),
            DropdownMenuItem(value: '>=', child: Text('Greater Than or Equal')),
            DropdownMenuItem(value: '<', child: Text('Less Than')),
            DropdownMenuItem(value: '<=', child: Text('Less Than or Equal')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedOperator = value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'Enter number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                final value = num.tryParse(_controller.text);
                if (value != null) {
                  widget.onApply(_selectedOperator, value);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DateFilterWidget extends StatefulWidget {
  final DateTime? initialValue;
  final String initialOperator;
  final void Function(String operator, DateTime value) onApply;

  const DateFilterWidget({
    required this.initialOperator,
    required this.onApply,
    super.key,
    this.initialValue,
  });

  @override
  DateFilterWidgetState createState() => DateFilterWidgetState();
}

class DateFilterWidgetState extends State<DateFilterWidget> {
  late String _selectedOperator;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.initialOperator;
    _selectedDate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void apply() {
    if (_selectedDate != null) {
      widget.onApply(_selectedOperator, _selectedDate!);
    } else {
      // Optionally handle no date selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
    }
  }
}

class BooleanFilterWidget extends StatefulWidget {
  final bool? initialValue;
  final void Function(bool value) onApply;

  const BooleanFilterWidget({
    required this.onApply,
    super.key,
    this.initialValue,
  });

  @override
  BooleanFilterWidgetState createState() => BooleanFilterWidgetState();
}

class BooleanFilterWidgetState extends State<BooleanFilterWidget> {
  bool? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select Value'),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const Text('True'),
            Radio<bool>(
              value: false,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const Text('False'),
          ],
        ),
      ],
    );
  }

  void apply() {
    if (_selectedValue != null) {
      widget.onApply(_selectedValue!);
    } else {
      // Optionally handle no selection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a value')),
      );
    }
  }
}

class ListFilterWidget extends StatefulWidget {
  final List<String> options;
  final List<String> initialValues;
  final void Function(List<String>) onApply;

  const ListFilterWidget({
    required this.options,
    required this.initialValues,
    required this.onApply,
    super.key,
  });

  @override
  ListFilterWidgetState createState() => ListFilterWidgetState();
}

class ListFilterWidgetState extends State<ListFilterWidget> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initialValues);
  }

  void apply() {
    widget.onApply(selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: selectedValues.contains(option),
          onChanged: (selected) {
            setState(() {
              if (selected == true) {
                selectedValues.add(option);
              } else {
                selectedValues.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
