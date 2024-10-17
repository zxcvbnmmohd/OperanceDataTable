// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

/// A class representing the width of a column in the OperanceDataTable.
class OperanceDataColumnWidth {
  /// Creates an instance of [OperanceDataColumnWidth].
  ///
  /// The [size] and [factor] parameters are optional.
  /// If [size] is provided, it will be used as the column width.
  /// If [size] is not provided, the width will be calculated based on the
  /// [factor].
  const OperanceDataColumnWidth({
    this.size,
    this.factor = 0.15,
  });

  /// The factor to calculate the column width if [size] is not provided.
  ///
  /// Defaults to `0.15`.
  final double factor;

  /// The fixed size of the column.
  ///
  /// If provided, this value will be used as the column width.
  final double? size;

  /// Returns the width of the column based on the [BuildContext].
  ///
  /// If [size] is provided, it returns the [size].
  /// Otherwise, it calculates the width based on the [factor] and the available
  /// width provided.
  double value(double width) {
    if (size != null) {
      return size!;
    }

    return width * factor;
  }
}
