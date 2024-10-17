# Changelog

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
