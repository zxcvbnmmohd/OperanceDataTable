// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class LoadingNotifier extends ValueNotifier<bool> {
  LoadingNotifier({bool isLoading = false}) : super(isLoading);

  void set({bool isLoading = false}) {
    value = isLoading;

    return notifyListeners();
  }
}
