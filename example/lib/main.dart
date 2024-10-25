import 'package:example/poke_api.dart';
import 'package:example/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:operance_datatable/operance_datatable.dart';
import 'package:operance_datatable/src/filter.dart';
import 'package:operance_datatable/src/filter_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'OperanceDataTable Demo';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF029BDD),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: title),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pokeApi = PokeApi();
  final _activeFilters = <String, dynamic>{};
  final TextEditingController _controller = TextEditingController();
  final InputDecoration _decoration = InputDecoration(
    hintText: 'Active Filters',
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final columnHeaderStyle = textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          _ActiveFilters(
            controller: _controller,
            decoration: _decoration,
          ),
          Expanded(
            child: OperanceDataTable<Pokemon>(
              onFetch: (limit, sort,
                  {bool isInitial = true,
                  Map<String, dynamic>? filters}) async {
                if (isInitial) {
                  return await _pokeApi.fetchPokemon(
                    limit: limit,
                    sort: sort.isNotEmpty
                        ? sort.map((key, value) {
                            return MapEntry(
                              key,
                              value == SortDirection.ascending,
                            );
                          })
                        : null,
                    filters: filters, // Pass filters to fetchPokemon
                  );
                }

                return await _pokeApi.fetchMore(limit: limit);
              },
              columns: <OperanceDataColumn<Pokemon>>[
                OperanceDataColumn<Pokemon>(
                  name: 'id',
                  sortable: true,
                  filterType: FilterType.numeric, // Specify filter type
                  columnHeader: _buildFilterableHeader(
                      'ID', 'id', columnHeaderStyle, FilterType.numeric),
                  cellBuilder: (context, item) {
                    return Text(item.id.toString());
                  },
                  numeric: true,
                  width: const OperanceDataColumnWidth(factor: 0.1),
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'name',
                  sortable: true,
                  filterType: FilterType.text, // Specify filter type
                  columnHeader: _buildFilterableHeader(
                      'Name', 'name', columnHeaderStyle, FilterType.text),
                  cellBuilder: (context, item) {
                    return Text(item.name);
                  },
                  getSearchableValue: (item) => item.name,
                  width: const OperanceDataColumnWidth(factor: 0.25),
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'forms',
                  sortable: true,
                  columnHeader: Text(
                    'Forms',
                    style: columnHeaderStyle,
                  ),
                  cellBuilder: (context, item) {
                    return Text(
                      item.forms.map((form) => form.name).join(', '),
                    );
                  },
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'abilities',
                  columnHeader: Text(
                    'Abilities',
                    style: columnHeaderStyle,
                  ),
                  cellBuilder: (context, item) {
                    return Text(
                      item.abilities
                          .map((ability) => ability.ability.name)
                          .join(', '),
                    );
                  },
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'type',
                  columnHeader: Text(
                    'Type',
                    style: columnHeaderStyle,
                  ),
                  cellBuilder: (context, item) {
                    return Text(
                      item.types.map((type) => type.type.name).join(', '),
                    );
                  },
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'weight',
                  sortable: true,
                  columnHeader: Text(
                    'Weight',
                    style: columnHeaderStyle,
                  ),
                  cellBuilder: (context, item) {
                    return Text(item.weight.toString());
                  },
                  numeric: true,
                  width: const OperanceDataColumnWidth(factor: 0.1),
                ),
                OperanceDataColumn<Pokemon>(
                  name: 'height',
                  sortable: true,
                  columnHeader: Text(
                    'Height',
                    style: columnHeaderStyle,
                  ),
                  cellBuilder: (context, item) {
                    return Text(item.height.toString());
                  },
                  numeric: true,
                  width: const OperanceDataColumnWidth(size: 400.0),
                ),
              ],
              expansionBuilder: (pokemon) {
                return SizedBox(
                  height: 100.0,
                  child: Wrap(
                    spacing: 8.0,
                    children: <Widget>[
                      Image.network(
                        pokemon.sprites.frontDefault,
                        fit: BoxFit.contain,
                      ),
                      Image.network(
                        pokemon.sprites.backDefault,
                        fit: BoxFit.contain,
                      ),
                      Image.network(
                        pokemon.sprites.frontShiny,
                        fit: BoxFit.contain,
                      ),
                      Image.network(
                        pokemon.sprites.backShiny,
                        fit: BoxFit.contain,
                      ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterableHeader(String title, String columnName,
      TextStyle? style, FilterType filterType) {
    return Row(
      children: [
        Text(title, style: style),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.blueAccent),
          tooltip: 'Filter $title',
          onPressed: () {
            _showFilterDialog(columnName, filterType);
          },
        ),
      ],
    );
  }

  void _showFilterDialog(String columnName, FilterType filterType) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          columnName: columnName,
          filterType: filterType,
          currentFilter: _activeFilters[columnName] as Filter?,
          onApply: (filter) {
            setState(() {
              _activeFilters[columnName] = filter;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: _activeFilters.entries.map((entry) {
          return Chip(
            label: Text('${entry.key}: ${entry.value}'),
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              setState(() {
                _activeFilters.remove(entry.key);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class _ActiveFilters extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;

  const _ActiveFilters({
    super.key,
    required this.controller,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your widget's UI here
    return TextField(
      controller: controller,
      decoration: decoration,
    );
  }
}
