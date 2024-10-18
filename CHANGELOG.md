# Changelog

## `1.0.5` - 2024-10-18

### Added

- Integrated `lefthook` for Git hooks automation.
- Added `pre-commit` hooks:
  - `sort-imports`: Sorts Dart imports using `import_sorter` and stages the changes.
  - `lint`: Analyzes the Dart files for linting issues.
  - `format`: Formats Dart files and stages the changes.
  - `pubspec-check`: Runs `flutter pub get` to ensure dependencies are up to date.
  - `unit-tests`: Runs unit tests using `flutter test`.
- Added `pre-push` hooks:
  - `full-lint`: Analyzes the entire project for linting issues.
  - `full-test`: Runs all unit tests.
  - `check-branch-name`: Validates the branch name against a predefined pattern to ensure it
     follows the naming convention.
- Added `currentPageIndex` and `onCurrentPageIndexChanged` properties to the `OperanceDataTable`
  widget to manage the current page index.
- Added an assertion to the `OperanceDataColumnWidth` class to ensure that the `factor` parameter is
  between 1 and 0.

### Changed

- Renamed _currentPage to _currentPageIndex in the OperanceDataController class.
- Updated the value function in the `OperanceDataColumnWidth` to be more concise and readable.
- Updated `pubspec.yaml` description to be shorter

### Removed

- Unused import in `OperanceDataColumnWidth` class.
- Extra space in `operance_data_decoration.dart` file.

## `1.0.4` - 2024-10-17

### Added

- Initial release of `OperanceDataTable`
- Core `OperanceDataTable` widget with the following features:
  - Customizable columns with sorting capabilities
  - Pagination support with customizable rows per page
  - Infinite scrolling option
  - Search functionality with customizable search field placement
  - Row selection with multi-select support
  - Expandable rows for additional details
  - Column reordering capability
  - Keyboard navigation support
  - Customizable loading and empty states
- `OperanceDataColumn` class for defining table columns with various options:
  - Custom cell builders
  - Sortable columns
  - Numeric columns
  - Custom width settings
- `OperanceDataController` for managing table state and data fetching
- Extensive customization options through `OperanceDataDecoration`:
  - Customizable colors (`OperanceDataColors`)
  - Customizable icons (`OperanceDataIcons`)
  - Customizable sizes (`OperanceDataSizes`)
  - Customizable styles (`OperanceDataStyles`)
  - Customizable UI options (`OperanceDataUI`)
- Created the `OperanceDataColumnWidth` class to represent the width of a column in the `OperanceDataTable`.
  - Supports a fixed column width using the `size` parameter.
  - Added a `factor` parameter (defaulting to 0.15) to calculate the width dynamically if `size` is not provided.
  - Introduced a `value` method that returns the column width based on the current screen size, considering platform-specific behaviors (iOS, Android, Web).
- Added the `OperanceDataColumnHeader` widget to represent the header of a data column in the `OperanceDataTable`.
  - Includes properties like `columnOrder`, `columns`, and callbacks such as `onChecked`, `onColumnDragged`, and `onSort`.
  - Supports decoration settings using the `OperanceDataDecoration` class.
  - Added support for selectable and expandable columns.
- Support for custom header widgets
- Built-in support for showing loading progress
- Customizable row dividers

### Changed

- N/A (Initial release)

### Deprecated

- N/A (Initial release)

### Removed

- N/A (Initial release)

### Fixed

- N/A (Initial release)

### Security

- N/A (Initial release)
