// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/models.dart';

/// A widget that represents a search field in the OperanceDataTable.
class OperanceDataSearchField extends StatelessWidget {
  /// Creates an instance of [OperanceDataSearchField].
  ///
  /// The [decoration], [controller], and [focusNode] parameters are required.
  /// The [onChanged] parameter is optional.
  const OperanceDataSearchField({
    required this.decoration,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    super.key,
  });

  /// The decoration settings for the search field.
  final OperanceDataDecoration decoration;

  /// The controller for the search field.
  final TextEditingController controller;

  /// The focus node for the search field.
  final FocusNode focusNode;

  /// Callback when the search field value changes.
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: decoration.sizes.searchWidth,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration.styles.searchDecoration,
        onChanged: onChanged,
      ),
    );
  }
}
