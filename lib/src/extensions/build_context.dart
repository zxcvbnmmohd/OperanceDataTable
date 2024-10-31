// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/models.dart';
import 'package:operance_datatable/src/notifiers/notifiers.dart';
import 'package:operance_datatable/src/providers/providers.dart';

extension BuildContextX on BuildContext {
  OperanceDataController<T> controller<T>() {
    return OperanceDataControllerProvider.of<T>(this);
  }

  OperanceDataDecoration decoration() {
    return OperanceDataDecorationProvider.of(this);
  }
}
