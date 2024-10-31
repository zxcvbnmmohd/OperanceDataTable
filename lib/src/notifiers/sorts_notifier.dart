// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/values/values.dart';

class SortsNotifier extends ValueNotifier<Map<String, SortDirection>> {
  SortsNotifier({
    Map<String, SortDirection> sorts = const {},
  }) : super(sorts);

  void setSort(String column, SortDirection? direction) {
    if (direction == null) {
      value.remove(column);
    } else {
      value[column] = direction;
    }

    return notifyListeners();
  }

  void clear() {
    value.clear();

    return notifyListeners();
  }
}
