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
            columnHeader: Text(
              'ID',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(item.id.toString());
            },
            numeric: true,
            sortable: true,
            width: const OperanceDataColumnWidth(factor: 0.1),
          ),
          OperanceDataColumn<Pokemon>(
            name: 'name',
            columnHeader: Text(
              'Name',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(item.name);
            },
            getSearchableValue: (item) => item.name,
            primary: true,
            sortable: true,
            width: const OperanceDataColumnWidth(factor: 0.2),
          ),
          OperanceDataColumn<Pokemon>(
            name: 'forms',
            columnHeader: Text(
              'Forms',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(
                item.forms.map((form) => form.name).join(', '),
              );
            },
            sortable: true,
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
            width: const OperanceDataColumnWidth(factor: 0.2),
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
            columnHeader: Text(
              'Weight',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(item.weight.toString());
            },
            numeric: true,
            sortable: true,
            width: const OperanceDataColumnWidth(factor: 0.1),
          ),
          OperanceDataColumn<Pokemon>(
            name: 'height',
            columnHeader: Text(
              'Height',
              style: columnHeaderStyle,
            ),
            cellBuilder: (context, item) {
              return Text(item.height.toString());
            },
            numeric: true,
            sortable: true,
            width: const OperanceDataColumnWidth(factor: 0.1),
          ),
        ],
        expansionBuilder: (context, pokemon) {
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
        onRowPressed: (pokemon) {},
        expandable: true,
        selectable: true,
        searchable: true,
        showHeader: true,
        showEmptyRows: true,
        showRowsPerPageOptions: true,
        allowColumnReorder: true,
        allowColumnHiding: true,
      ),
    );
  }
}
