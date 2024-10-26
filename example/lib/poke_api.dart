import 'dart:convert';
import 'package:example/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:operance_datatable/src/filter.dart';

abstract class IPokeApi {
  Future<(List<Pokemon>, bool)> fetchPokemon({
    required int limit,
    Map<String, bool>? sort,
    Map<String, dynamic>? filters,
  });

  Future<(List<Pokemon>, bool)> fetchMore({
    required int limit,
  });
}

class PokeApi implements IPokeApi {
  static const _baseUrl = 'https://pokeapi.co/api/v2';
  final cache = <Pokemon>[];
  var total = 0;
  var offset = 0;
  String? nextToken;
  Map<String, bool>? _sort;

  @override
  Future<(List<Pokemon>, bool)> fetchPokemon({
    required int limit,
    Map<String, bool>? sort,
    Map<String, dynamic>? filters,
  }) async {
    try {
      debugPrint('Fetching Pokemon with filters: $filters'); // Debug log

      // Apply filters to the query if they exist
      String query = '';
      if (filters != null && filters.isNotEmpty) {
        query = _buildFilterQuery(filters);
        debugPrint('Built filter query: $query'); // Debug log
      }

      // Your existing API call logic here
      final response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // Fetch detailed data for each Pokemon
        final List<Pokemon> pokemon = await Future.wait(
          results.map((result) async {
            final detailResponse = await http.get(Uri.parse(result['url']));
            if (detailResponse.statusCode == 200) {
              return Pokemon.fromJson(json.decode(detailResponse.body));
            }
            throw Exception('Failed to load Pokemon details');
          }),
        );

        debugPrint('Fetched ${pokemon.length} Pokemon'); // Debug log
        return (pokemon, data['next'] != null);
      }
      throw Exception('Failed to load Pokemon');
    } catch (e) {
      debugPrint('Error in fetchPokemon: $e'); // Debug log
      rethrow;
    }
  }

  @override
  Future<(List<Pokemon>, bool)> fetchMore({
    required int limit,
  }) async {
    if (nextToken == null) {
      return (<Pokemon>[], false);
    }

    final response = await http.get(Uri.parse('$nextToken?limit=$limit'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokemons');
    }

    final data = json.decode(response.body);
    final pokemon = <Pokemon>[];

    for (final result in data['results'] as List<dynamic>) {
      final pokemonResponse = await http.get(Uri.parse(result['url']));
      pokemon.add(Pokemon.fromJson(json.decode(pokemonResponse.body)));
    }

    cache.addAll(pokemon);
    nextToken = data['next'] as String;

    return (_sortPokemon(pokemon), total > cache.length);
  }

  List<Pokemon> _sortPokemon(List<Pokemon> pokemon) {
    if (_sort == null || _sort!.isEmpty) {
      return pokemon;
    }

    final sortedPokemon = List<Pokemon>.from(pokemon);

    _sort!.forEach((sortField, ascending) {
      if (sortField == 'id') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.id.compareTo(b.id);
          } else {
            return b.id.compareTo(a.id);
          }
        });
      }

      if (sortField == 'name') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.name.compareTo(b.name);
          } else {
            return b.name.compareTo(a.name);
          }
        });
      }

      if (sortField == 'forms') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.forms.first.name.compareTo(b.forms.first.name);
          } else {
            return b.forms.first.name.compareTo(a.forms.first.name);
          }
        });
      }

      if (sortField == 'abilities') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.abilities.first.ability.name
                .compareTo(b.abilities.first.ability.name);
          } else {
            return b.abilities.first.ability.name
                .compareTo(a.abilities.first.ability.name);
          }
        });
      }

      if (sortField == 'type') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.types.first.type.name.compareTo(b.types.first.type.name);
          } else {
            return b.types.first.type.name.compareTo(a.types.first.type.name);
          }
        });
      }

      if (sortField == 'weight') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.weight.compareTo(b.weight);
          } else {
            return b.weight.compareTo(a.weight);
          }
        });
      }

      if (sortField == 'height') {
        sortedPokemon.sort((a, b) {
          if (ascending) {
            return a.height.compareTo(b.height);
          } else {
            return b.height.compareTo(a.height);
          }
        });
      }
    });

    return sortedPokemon;
  }

  String _buildFilterQuery(Map<String, dynamic> filters) {
    final queryParams = <String>[];

    filters.forEach((key, value) {
      if (value is Filter) {
        final filterValue = value.value;
        final operator =
            value.operator ?? '='; // Provide default operator if null

        switch (key) {
          case 'id':
          case 'weight':
          case 'height':
            queryParams.add('$key${_getOperatorSymbol(operator)}$filterValue');
            break;
          case 'name':
            if (operator == 'contains') {
              queryParams.add('name_like=$filterValue');
            } else {
              queryParams.add('name=$filterValue');
            }
            break;
          // Add other filter cases as needed
        }
      }
    });

    return queryParams.isEmpty ? '' : '&${queryParams.join('&')}';
  }

  String _getOperatorSymbol(String operator) {
    switch (operator) {
      case '>':
        return '[gt]';
      case '>=':
        return '[gte]';
      case '<':
        return '[lt]';
      case '<=':
        return '[lte]';
      case '=':
        return '';
      default:
        return '';
    }
  }
}
