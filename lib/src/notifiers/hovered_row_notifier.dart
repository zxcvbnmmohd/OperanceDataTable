// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class HoveredRowNotifier extends ValueNotifier<int?> {
  HoveredRowNotifier({int? row}) : super(row);

  void set(int row) {
    value = row;

    return notifyListeners();
  }

  void clear() {
    value = null;

    return notifyListeners();
  }
}
