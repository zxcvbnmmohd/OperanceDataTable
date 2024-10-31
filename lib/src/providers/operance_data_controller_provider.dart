// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/notifiers/notifiers.dart';

class OperanceDataControllerProvider<T> extends InheritedWidget {
  const OperanceDataControllerProvider({
    required this.controller,
    required super.child,
    super.key,
  });

  final OperanceDataController<T> controller;

  static OperanceDataController<T> of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            OperanceDataControllerProvider<T>>()!
        .controller;
  }

  @override
  bool updateShouldNotify(OperanceDataControllerProvider<T> oldWidget) {
    return controller != oldWidget.controller;
  }
}
