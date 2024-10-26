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
    try {
      print('Applying filter: type=$type, operator=$operator');
      print(
          'Comparing fieldValue: "$fieldValue" (${fieldValue.runtimeType}) with filterValue: "$value" (${value.runtimeType})');

      if (fieldValue == null) {
        print('Field value is null, returning false');
        return false;
      }

      switch (type) {
        case FilterType.text:
          final stringValue = fieldValue.toString().toLowerCase();
          final filterValue = (value as String).toLowerCase();

          switch (operator) {
            case 'contains':
              return stringValue.contains(filterValue);
            case 'equals':
              return stringValue == filterValue;
            case 'startsWith':
              return stringValue.startsWith(filterValue);
            case 'endsWith':
              return stringValue.endsWith(filterValue);
            default:
              print('Unknown text operator: $operator');
              return false;
          }

        case FilterType.numeric:
          final numValue = num.tryParse(fieldValue.toString());
          final filterNum = num.tryParse(value.toString());

          if (numValue == null || filterNum == null) {
            print('Could not parse numeric values');
            return false;
          }

          switch (operator) {
            case '=':
              return numValue == filterNum;
            case '>':
              return numValue > filterNum;
            case '>=':
              return numValue >= filterNum;
            case '<':
              return numValue < filterNum;
            case '<=':
              return numValue <= filterNum;
            case '!=':
              return numValue != filterNum;
            default:
              print('Unknown numeric operator: $operator');
              return false;
          }

        default:
          print('Unsupported filter type: $type');
          return false;
      }
    } catch (e) {
      print('Error in filter.apply: $e');
      return false;
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
