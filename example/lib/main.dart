import 'package:example/poke_api.dart';
import 'package:example/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:operance_datatable/operance_datatable.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
      body: OperanceDataTable<Pokemon>(
        onFetch: (limit, sort, {bool isInitial = true}) async {
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
            );
          }

          return await _pokeApi.fetchMore(limit: limit);
        },
        columns: <OperanceDataColumn<Pokemon>>[
          OperanceDataColumn<Pokemon>(
            name: 'id',
            sortable: true,
            columnHeader: Text(
              'ID',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(item.id.toString());
            },
            numeric: true,
            width: const OperanceDataColumnWidth(factor: 0.1),
          ),
          OperanceDataColumn<Pokemon>(
            name: 'name',
            sortable: true,
            columnHeader: Text(
              'Name',
              style: columnHeaderStyle,
            ),
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
        searchable: false,
        showHeader: false,
        showColumnHeader: false,
        showFooter: false,
        showEmptyRows: false,
        showRowsPerPageOptions: true,
        allowColumnReorder: true,
      ),
    );
  }
}
