import 'package:flutter/material.dart';

class TextFilterWidget extends StatefulWidget {
  final String? initialValue;
  final String initialOperator;
  final void Function(String operator, String value) onApply;
  final VoidCallback onClear;

  const TextFilterWidget({
    required this.initialOperator,
    required this.onApply,
    required this.onClear,
    super.key,
    this.initialValue,
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
    _selectedOperator = widget.initialOperator;
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          decoration: const InputDecoration(labelText: 'Operator'),
          items: const [
            DropdownMenuItem(value: 'contains', child: Text('Contains')),
            DropdownMenuItem(value: 'equals', child: Text('Equals')),
            DropdownMenuItem(value: 'startsWith', child: Text('Starts With')),
            DropdownMenuItem(value: 'endsWith', child: Text('Ends With')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedOperator = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'Enter text',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onApply(_selectedOperator, _controller.text.trim());
                }
              },
              child: const Text('Apply'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                widget.onClear();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
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
            setState(() {
              _selectedOperator = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'Enter number',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void apply() {
    final value = num.tryParse(_controller.text);
    if (value != null) {
      widget.onApply(_selectedOperator, value);
    } else {
      // Optionally handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
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
