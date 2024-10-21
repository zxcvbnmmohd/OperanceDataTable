# OperanceDataTable

[![GitHub Stars](https://img.shields.io/github/stars/zxcvbnmmohd/OperanceDataTable.svg?logo=github)](https://github.com/zxcvbnmmohd/OperanceDataTable/stargazers)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/zxcvbnmmohd/OperanceDataTable/raw/main/LICENSE)
![Coverage](https://github.com/zxcvbnmmohd/OperanceDataTable/raw/main/coverage_badge.svg?sanitize=true)

[![Package](https://img.shields.io/pub/v/operance_datatable.svg?logo=flutter)](https://pub.dartlang.org/packages/operance_datatable)
[![Platform](https://img.shields.io/badge/platform-all-brightgreen.svg?logo=flutter)](https://img.shields.io/badge/platform-android%20|%20ios%20|%20linux%20|%20macos%20|%20web%20|%20windows-green.svg)
[![Likes](https://img.shields.io/pub/likes/operance_datatable?logo=flutter)](https://pub.dev/packages/operance_datatable/score)
[![Points](https://img.shields.io/pub/points/operance_datatable?logo=flutter)](https://pub.dev/packages/operance_datatable/score)
[![Popularity](https://img.shields.io/pub/popularity/operance_datatable?logo=flutter)](https://pub.dev/packages/operance_datatable/score)

OperanceDataTable is a powerful, flexible, and highly customizable data table widget for Flutter applications. It provides a rich set of features that make displaying and interacting with tabular data a breeze, while offering an exceptional developer experience.

![Screenshot of OperanceDataTable](https://github.com/zxcvbnmmohd/OperanceDataTable/raw/main/showcase.png)

## Features

- **Effortless Data Handling**: Easily manage and display large datasets with built-in pagination and infinite scrolling support.
- **Advanced Sorting**: Enable multi-column sorting with customizable sort icons and behavior.
- **Flexible Search**: Implement powerful search functionality with customizable search field decoration, placement and behavior.
- **Row Selection**: Allow users to select single or multiple rows with customizable selection behavior.
- **Expandable Rows**: Create interactive tables with expandable rows for additional details or nested data.
- **Column Reordering**: Enable users to reorder columns for a personalized view of the data.
- **Highly Customizable**: Tailor every aspect of the table's appearance and behavior to match your app's design and requirements.
- **Responsive Design**: Automatically adjusts to different screen sizes and orientations.
- **Keyboard Navigation**: Enhance accessibility with built-in keyboard navigation support.
- **Theming Support**: Easily integrate with your app's theme for a cohesive look and feel.

To see example of the following OperanceDataTable on a device or simulator:

```shell
cd example/
flutter run --release
```

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  operance_datatable: ^1.0.6
```

Then run:

```shell
flutter pub get
```

## Usage

To use OperanceDataTable, first import the package:

```dart
import 'package:operance_datatable/operance_datatable.dart';
```

Then, you can create an OperanceDataTable widget in your Flutter app:

```dart
OperanceDataTable<YourDataType>(
  columns: <OperanceDataColumn<YourDataType>[
    // Define your columns here
  ],
  onFetch: (limit, sort, {bool isInitial = true}) async {
    // Implement your data fetching logic here
  },
  // Add more configuration options as needed
)
```

## Example

Here's a more complete example of how to use OperanceDataTable:

```dart
import 'package:flutter/material.dart';
import 'package:operance_datatable/operance_datatable.dart';

class OperanceDataTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OperanceDataTable Example')),
      body: OperanceDataTable<Pokemon>(
        onFetch: (limit, sort, {bool isInitial = true}) async {
          // Implement your data fetching logic hered
          if (isInitial) {
            final pokemon = await PokeApi.fetchPokemon(
              limit: limit,
              sort: sort?.map((key, value) => MapEntry(key, value == SortDirection.ascending)),
            );

            return (pokemon, PokeApi.hasNextPage);
          } else {
            final pokemon = await PokeApi.fetchMore(limit: limit);

            return (pokemon, PokeApi.hasNextPage);
          }
        },
        columns: <OperanceDataColumn<Pokemon>>[
          OperanceDataColumn<Pokemon>(
            name: 'id',
            sortable: true,
            columnHeader: Text('ID'),
            cellBuilder: (context, item) => Text(item.id.toString()),
            numeric: true,
            getValue: (item) => item.id,
            width: const OperanceDataColumnWidth(factor: 0.1),
          ),
          OperanceDataColumn<Pokemon>(
            name: 'name',
            sortable: true,
            columnHeader: Text('Name'),
            cellBuilder: (context, item) => Text(item.name),
            getValue: (item) => item.name,
            getSearchableValue: (item) => item.name,
            width: const OperanceDataColumnWidth(factor: 0.25),
          ),
          // Add more columns as needed
        ],
        expansionBuilder: (pokemon) {
          return SizedBox(
            height: 100.0,
            child: Wrap(
              spacing: 8.0,
              children: <Widget>[
                Image.network(pokemon.sprites.frontDefault),
                Image.network(pokemon.sprites.backDefault),
                Image.network(pokemon.sprites.frontShiny),
                Image.network(pokemon.sprites.backShiny),
              ],
            ),
          );
        },
        expandable: true,
        selectable: true,
        searchable: true,
        showHeader: true,
        showEmptyRows: true,
        showRowsPerPageOptions: true,
        allowColumnReorder: true,
      ),
    );
  }
}
```

## Customization

OperanceDataTable offers extensive customization options through the `OperanceDataDecoration` class. You can customize colors, icons, sizes, styles, and UI behavior. Here's an example of how to customize the table's appearance:

```dart
OperanceDataTable<YourDataType>(
  // ... other properties
  decoration: OperanceDataDecoration(
    colors: OperanceDataColors(
      headerColor: Colors.blue[100],
      rowColor: Colors.white,
      rowHoverColor: Colors.blue[50],
    ),
    icons: OperanceDataIcons(
      columnHeaderSortAscendingIcon: Icons.arrow_upward,
      columnHeaderSortDescendingIcon: Icons.arrow_downward,
    ),
    sizes: OperanceDataSizes(
      headerHeight: 70.0,
      rowHeight: 60.0,
    ),
    styles: OperanceDataStyles(
      searchDecoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    ),
    ui: OperanceDataUI(
      animationDuration: 300,
      rowsPerPageOptions: [10, 20, 50, 100],
      searchPosition: SearchPosition.left,
    ),
  ),
)
```

## Contributing

We welcome contributions to OperanceDataTable! Please see our [contributing guidelines](./CONTRIBUTING.md) for more information on how to get started.

## License

OperanceDataTable is released under the MIT License. See the [LICENSE](./LICENSE) file for details.