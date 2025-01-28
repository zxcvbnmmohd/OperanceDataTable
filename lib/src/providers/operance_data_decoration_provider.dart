// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/models.dart';

class OperanceDataDecorationProvider extends InheritedWidget {
  const OperanceDataDecorationProvider({
    required this.decoration,
    required super.child,
    super.key,
  });

  final OperanceDataDecoration decoration;

  static OperanceDataDecoration of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OperanceDataDecorationProvider>()!
        .decoration;
  }

  @override
  bool updateShouldNotify(OperanceDataDecorationProvider oldWidget) {
    return decoration != oldWidget.decoration;
  }
}
