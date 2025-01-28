// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/models/operance_data_decoration.dart';

void main() {
  group('Given an OperanceDataDecoration instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const decoration = OperanceDataDecoration(
          colors: OperanceDataColors(
            loadingBackgroundColor: Color(0xFF000000),
            loadingProgressColor: Color(0xFFFFFFFF),
          ),
          icons: OperanceDataIcons(
            columnHeaderSortAscendingIcon: Icons.add,
            columnHeaderSortDescendingIcon: Icons.remove,
          ),
          sizes: OperanceDataSizes(
            headerHeight: 70.0,
            rowHeight: 60.0,
          ),
          styles: OperanceDataStyles(
            headerDecoration: BoxDecoration(color: Color(0xFF123456)),
            searchDecoration: InputDecoration(hintText: 'Custom Search'),
          ),
          ui: OperanceDataUI(
            animationDuration: 500,
            rowsPerPageOptions: <int>[10, 20, 30],
          ),
        );

        expect(
          decoration.colors.loadingBackgroundColor,
          const Color(0xFF000000),
        );
        expect(
          decoration.colors.loadingProgressColor,
          const Color(0xFFFFFFFF),
        );
        expect(
          decoration.icons.columnHeaderSortAscendingIcon,
          Icons.add,
        );
        expect(
          decoration.icons.columnHeaderSortDescendingIcon,
          Icons.remove,
        );
        expect(
          decoration.sizes.headerHeight,
          70.0,
        );
        expect(
          decoration.sizes.rowHeight,
          60.0,
        );
        expect(
          decoration.styles.headerDecoration.color,
          const Color(0xFF123456),
        );
        expect(
          decoration.styles.searchDecoration.hintText,
          'Custom Search',
        );
        expect(
          decoration.ui.animationDuration,
          500,
        );
        expect(
          decoration.ui.rowsPerPageOptions,
          <int>[10, 20, 30],
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const decoration = OperanceDataDecoration();

        expect(
          decoration.colors.loadingBackgroundColor,
          const Color(0xFFF7F7F7),
        );
        expect(
          decoration.icons.columnHeaderSortAscendingIcon,
          Icons.arrow_upward,
        );
        expect(
          decoration.sizes.headerHeight,
          60.0,
        );
        expect(
          decoration.styles.headerDecoration.color,
          const Color(0xFFE0E0E0),
        );
        expect(
          decoration.ui.animationDuration,
          300,
        );
      });
    });
  });

  group('Given an OperanceDataColors instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const colors = OperanceDataColors(
          loadingBackgroundColor: Color(0xFF000000),
          loadingProgressColor: Color(0xFFFFFFFF),
        );

        expect(
          colors.loadingBackgroundColor,
          const Color(0xFF000000),
        );
        expect(
          colors.loadingProgressColor,
          const Color(0xFFFFFFFF),
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const colors = OperanceDataColors();

        expect(
          colors.loadingBackgroundColor,
          const Color(0xFFF7F7F7),
        );
        expect(
          colors.loadingProgressColor,
          const Color(0xFF000000),
        );
      });
    });
  });

  group('Given an OperanceDataIcons instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const icons = OperanceDataIcons(
          columnHeaderSortAscendingIcon: Icons.add,
          columnHeaderSortDescendingIcon: Icons.remove,
        );

        expect(
          icons.columnHeaderSortAscendingIcon,
          Icons.add,
        );
        expect(
          icons.columnHeaderSortDescendingIcon,
          Icons.remove,
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const icons = OperanceDataIcons();

        expect(
          icons.columnHeaderSortAscendingIcon,
          Icons.arrow_upward,
        );
        expect(
          icons.columnHeaderSortDescendingIcon,
          Icons.arrow_downward,
        );
      });
    });
  });

  group('Given an OperanceDataSizes instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const sizes = OperanceDataSizes(
          headerHeight: 70.0,
          rowHeight: 60.0,
        );

        expect(
          sizes.headerHeight,
          70.0,
        );
        expect(
          sizes.rowHeight,
          60.0,
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const sizes = OperanceDataSizes();

        expect(
          sizes.headerHeight,
          60.0,
        );
        expect(
          sizes.rowHeight,
          50.0,
        );
      });
    });
  });

  group('Given an OperanceDataStyles instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const styles = OperanceDataStyles(
          headerDecoration: BoxDecoration(color: Color(0xFF123456)),
          searchDecoration: InputDecoration(hintText: 'Custom Search'),
        );

        expect(
          styles.headerDecoration.color,
          const Color(0xFF123456),
        );
        expect(
          styles.searchDecoration.hintText,
          'Custom Search',
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const styles = OperanceDataStyles();

        expect(
          styles.headerDecoration.color,
          const Color(0xFFE0E0E0),
        );
        expect(
          styles.searchDecoration.hintText,
          'Search',
        );
      });
    });
  });

  group('Given an OperanceDataUI instance', () {
    group('When all parameters are provided', () {
      test('Then it should create an instance with the provided values', () {
        const ui = OperanceDataUI(
          animationDuration: 500,
          rowsPerPageOptions: <int>[10, 20, 30],
        );

        expect(
          ui.animationDuration,
          500,
        );
        expect(
          ui.rowsPerPageOptions,
          <int>[10, 20, 30],
        );
      });
    });

    group('When default parameters are used', () {
      test('Then it should create an instance with default values', () {
        const ui = OperanceDataUI();

        expect(
          ui.animationDuration,
          300,
        );
        expect(
          ui.rowsPerPageOptions,
          <int>[25, 50, 100],
        );
      });
    });
  });
}
