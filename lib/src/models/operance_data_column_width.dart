/// A class representing the width of a column in the OperanceDataTable.
class OperanceDataColumnWidth {
  /// Creates an instance of [OperanceDataColumnWidth].
  ///
  /// Optional parameters:
  ///   - [size]: The fixed size of the column. If not provided, the width will
  ///     be calculated based on the [factor].
  ///   - [factor]: The factor of the total table width to be used for the
  ///     column width. Must be between 0 and 1. Defaults to 0.15.
  const OperanceDataColumnWidth({
    this.size,
    this.factor = 0.15,
  }) : assert(
          factor > 0 && factor <= 1,
          'factor must be between 0 and 1',
        );

  /// The factor of the total table width to be used for the column width.
  final double factor;

  /// The fixed size of the column.
  final double? size;

  /// Returns the width of the column based on the total table width.
  ///
  /// If [size] is provided, it returns the [size]. Otherwise, it calculates the
  /// width based on the [factor] and the total table width.
  double value(double width) => size ?? width * factor;
}
