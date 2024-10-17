import 'dart:convert';
import 'package:example/pokemon.dart';
import 'package:http/http.dart' as http;

abstract class IPokeApi {
  Future<(List<Pokemon>, bool)> fetchPokemon({
    required int limit,
    Map<String, bool>? sort,
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
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'),
    );

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
    total = data['count'] as int;
    nextToken = data['next'] as String;
    _sort = sort;

    return (_sortPokemon(pokemon), total > cache.length);
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
}
