/// A class representing the width of a column in the OperanceDataTable.
class OperanceDataColumnWidth {
  /// Creates an instance of [OperanceDataColumnWidth].
  ///
  /// The [size] parameter is optional and takes precedence over [factor].
  /// If [size] is provided, it will be used as the fixed column width.
  /// If [size] is not provided, the width will be calculated based on the
  /// [factor], which defaults to 0.15 (15% of the available width).
  const OperanceDataColumnWidth({
    this.size,
    this.factor = 0.15,
  }) : assert(
          factor > 0 && factor <= 1,
          'Factor must be between 0 and 1',
        );

  /// The factor to calculate the column width if [size] is not provided.
  ///
  /// Must be a value between 0 and 1, representing a percentage of the
  /// available width.
  final double factor;

  /// If provided, this value will be used as the column width,
  /// ignoring [factor].
  final double? size;

  /// Returns the width of the column based on the available [width].
  ///
  /// If [size] is provided, it returns the [size].
  /// Otherwise, it calculates the width based on the [factor] and the
  /// available [width].
  double value(double width) => size ?? width * factor;
}
