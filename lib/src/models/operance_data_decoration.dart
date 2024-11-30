// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/values/values.dart';

/// A class representing the decoration settings for the OperanceDataTable.
class OperanceDataDecoration {
  /// Creates an instance of [OperanceDataDecoration].
  ///
  /// The [colors], [icons], [sizes], [styles], and [ui] parameters are
  /// optional.
  const OperanceDataDecoration({
    this.colors = const OperanceDataColors(),
    this.icons = const OperanceDataIcons(),
    this.sizes = const OperanceDataSizes(),
    this.styles = const OperanceDataStyles(),
    this.ui = const OperanceDataUI(),
  });

  /// The color settings for the data table.
  final OperanceDataColors colors;

  /// The icon settings for the data table.
  final OperanceDataIcons icons;

  /// The size settings for the data table.
  final OperanceDataSizes sizes;

  /// The style settings for the data table.
  final OperanceDataStyles styles;

  /// The UI settings for the data table.
  final OperanceDataUI ui;
}

/// A class representing the color settings for the OperanceDataTable.
class OperanceDataColors {
  /// Creates an instance of [OperanceDataColors].
  ///
  /// All parameters are optional and have default values.
  const OperanceDataColors({
    this.loadingBackgroundColor = const Color(0xFFF7F7F7),
    this.loadingProgressColor = const Color(0xFF000000),
    this.columnHeaderSortIconEnabledColor = const Color(0xFF000000),
    this.columnHeaderSortIconDisabledColor = const Color(0xFFA5ACB4),
    this.rowColor = const Color(0xFFFFFFFF),
    this.rowHoverColor = const Color(0xFFEBECEE),
    this.rowDividerColor = const Color(0xFFE0E0E0),
    this.rowSelectedColor = const Color(0xFFE6E6E6),
    this.rowExpansionIconColor = const Color(0xFF000000),
  });

  /// The background color while loading.
  final Color loadingBackgroundColor;

  /// The color of the loading progress indicator.
  final Color loadingProgressColor;

  /// The color of the sort icon when enabled.
  final Color columnHeaderSortIconEnabledColor;

  /// The color of the sort icon when disabled.
  final Color columnHeaderSortIconDisabledColor;

  /// The color of the rows.
  final Color rowColor;

  /// The color of the rows when hovered.
  final Color rowHoverColor;

  /// The color of the row dividers.
  final Color rowDividerColor;

  /// The color of the rows when selected.
  final Color rowSelectedColor;

  /// The color of the row expansion icon.
  final Color rowExpansionIconColor;
}

/// A class representing the icon settings for the OperanceDataTable.
class OperanceDataIcons {
  /// Creates an instance of [OperanceDataIcons].
  ///
  /// All parameters are optional and have default values.
  const OperanceDataIcons({
    this.columnHeaderSortAscendingIcon = Icons.arrow_upward,
    this.columnHeaderSortDescendingIcon = Icons.arrow_downward,
    this.rowExpansionIconCollapsed = Icons.keyboard_arrow_up,
    this.rowExpansionIconExpanded = Icons.keyboard_arrow_down,
    this.previousPageIcon = Icons.chevron_left,
    this.nextPageIcon = Icons.chevron_right,
  });

  /// The icon for sorting the column in ascending order.
  final IconData columnHeaderSortAscendingIcon;

  /// The icon for sorting the column in descending order.
  final IconData columnHeaderSortDescendingIcon;

  /// The icon for a collapsed row expansion.
  final IconData rowExpansionIconCollapsed;

  /// The icon for an expanded row.
  final IconData rowExpansionIconExpanded;

  /// The icon for the previous page button.
  final IconData previousPageIcon;

  /// The icon for the next page button.
  final IconData nextPageIcon;
}

/// A class representing the size settings for the OperanceDataTable.
class OperanceDataSizes {
  /// Creates an instance of [OperanceDataSizes].
  ///
  /// All parameters are optional and have default values.
  const OperanceDataSizes({
    this.headerHeight = 60.0,
    this.headerHorizontalPadding = 16.0,
    this.searchWidth = 500.0,
    this.loadingHeight = 10.0,
    this.columnHeaderHeight = 60.0,
    this.columnHeaderSortIconSize = 14.0,
    this.rowHeight = 50.0,
    this.rowDividerHeight = 1.0,
    this.rowDividerThickness = 1.0,
    this.rowDividerIndent = 0.0,
    this.rowDividerEndIndent = 0.0,
    this.footerHeight = 60.0,
    this.footerHorizontalPadding = 16.0,
  });

  /// The height of the header.
  final double headerHeight;

  /// The horizontal padding of the header.
  final double headerHorizontalPadding;

  /// The width of the search field.
  final double searchWidth;

  /// The height of the loading indicator.
  final double loadingHeight;

  /// The height of the column header.
  final double columnHeaderHeight;

  /// The height of the column header sort icon.
  final double columnHeaderSortIconSize;

  /// The height of the rows.
  final double rowHeight;

  /// The height of the row dividers.
  final double rowDividerHeight;

  /// The thickness of the row dividers.
  final double rowDividerThickness;

  /// The indent of the row dividers.
  final double rowDividerIndent;

  /// The end indent of the row dividers.
  final double rowDividerEndIndent;

  /// The height of the footer.
  final double footerHeight;

  /// The horizontal padding of the footer.
  final double footerHorizontalPadding;
}

/// A class representing the style settings for the OperanceDataTable.
class OperanceDataStyles {
  /// Creates an instance of [OperanceDataStyles].
  ///
  /// All parameters are optional and have default values.
  const OperanceDataStyles({
    this.headerDecoration = const BoxDecoration(
      color: Color(0xFFE0E0E0),
    ),
    this.columnHeaderDecoration = const BoxDecoration(
      color: Color(0xFFF0F0F0),
      border: Border(
        top: BorderSide(
          color: Color(0xFFBBC0C6),
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Color(0xFFBBC0C6),
          width: 1.0,
        ),
      ),
    ),
    this.searchDecoration = const InputDecoration(
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.rowExpandedContainerPadding = const EdgeInsets.all(8.0),
    this.rowsPerPageTextStyle = const TextStyle(
      fontSize: 14.0,
      color: Color(0xFF000000),
    ),
    this.loadingBorderRadius = const BorderRadius.all(
      Radius.circular(1.0),
    ),
    this.footerDecoration = const BoxDecoration(
      color: Color(0xFFE0E0E0),
    ),
  });

  /// The decoration for the header.
  final BoxDecoration headerDecoration;

  /// The decoration for the column header.
  final BoxDecoration columnHeaderDecoration;

  /// The decoration for the search field.
  final InputDecoration searchDecoration;

  /// The padding for the cells.
  final EdgeInsets cellPadding;

  /// The padding for the expanded row container.
  final EdgeInsets rowExpandedContainerPadding;

  /// The text style for the rows per page text.
  final TextStyle rowsPerPageTextStyle;

  /// The border radius for the loading indicator.
  final BorderRadius loadingBorderRadius;

  /// The decoration for the footer.
  final BoxDecoration footerDecoration;
}

/// A class representing the UI settings for the OperanceDataTable.
class OperanceDataUI {
  /// Creates an instance of [OperanceDataUI].
  ///
  /// All parameters are optional and have default values.
  const OperanceDataUI({
    this.animationDuration = 300,
    this.rowsPerPageOptions = const <int>[25, 50, 100],
    this.searchPosition = SearchPosition.right,
    this.horizontalScrollPhysics = const BouncingScrollPhysics(),
    this.verticalScrollPhysics = const BouncingScrollPhysics(),
    this.columnHeaderSortIconSpaced = true,
    this.rowCursor = SystemMouseCursors.click,
    this.rowDividerEnabled = true,
    this.rowExpansionCursor = SystemMouseCursors.click,
    this.rowsPerPageText = 'Rows per page',
  });

  /// The duration of animations in milliseconds.
  final int animationDuration;

  /// The options for the number of rows per page.
  final List<int> rowsPerPageOptions;

  /// The position of the search field.
  final SearchPosition searchPosition;

  /// The scroll physics for horizontal scrolling.
  final ScrollPhysics horizontalScrollPhysics;

  /// The scroll physics for vertical scrolling.
  final ScrollPhysics verticalScrollPhysics;

  /// Whether the sort icon in the column header is spaced.
  final bool columnHeaderSortIconSpaced;

  /// The cursor for rows.
  final MouseCursor rowCursor;

  /// Whether the row divider is enabled.
  final bool rowDividerEnabled;

  /// The cursor for row expansion.
  final MouseCursor rowExpansionCursor;

  /// The text for the rows per page label.
  final String rowsPerPageText;
}
