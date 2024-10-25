enum FilterType { text, numeric, date, boolean, list }

class Filter {
  final String field;
  final FilterType type;
  final dynamic value;
  final String? operator;

  const Filter({
    required this.field,
    required this.type,
    required this.value,
    this.operator,
  });

  bool apply(dynamic fieldValue) {
    switch (type) {
      case FilterType.text:
        return _applyTextFilter(fieldValue);
      case FilterType.numeric:
        return _applyNumericFilter(fieldValue);
      case FilterType.date:
        return _applyDateFilter(fieldValue);
      case FilterType.boolean:
        return fieldValue == value;
      case FilterType.list:
        return (value as List).contains(fieldValue);
    }
  }

  bool _applyTextFilter(String? fieldValue) {
    if (fieldValue == null) return false;
    switch (operator) {
      case 'contains':
        return fieldValue.toLowerCase().contains(value.toLowerCase());
      case 'equals':
        return fieldValue.toLowerCase() == value.toLowerCase();
      case 'startsWith':
        return fieldValue.toLowerCase().startsWith(value.toLowerCase());
      case 'endsWith':
        return fieldValue.toLowerCase().endsWith(value.toLowerCase());
      default:
        return fieldValue.toLowerCase().contains(value.toLowerCase());
    }
  }

  bool _applyNumericFilter(num? fieldValue) {
    if (fieldValue == null) return false;
    switch (operator) {
      case '>':
        return fieldValue > value;
      case '>=':
        return fieldValue >= value;
      case '<':
        return fieldValue < value;
      case '<=':
        return fieldValue <= value;
      case '=':
        return fieldValue == value;
      default:
        return fieldValue == value;
    }
  }

  bool _applyDateFilter(DateTime? fieldValue) {
    if (fieldValue == null) return false;
    final filterDate = value as DateTime;
    switch (operator) {
      case 'before':
        return fieldValue.isBefore(filterDate);
      case 'after':
        return fieldValue.isAfter(filterDate);
      case 'on':
        return fieldValue.isAtSameMomentAs(filterDate);
      default:
        return fieldValue.isAtSameMomentAs(filterDate);
    }
  }

  // Add this factory constructor
  factory Filter.clear(String field) => Filter(
        field: field,
        type: FilterType.text,
        value: null,
        operator: 'none',
      );
}
