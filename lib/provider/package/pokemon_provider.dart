import 'dart:math';

import 'package:poke_battle/model/package/pokemon_model.dart';
import 'package:poke_battle/provider/dio/poke_api_client.dart';

class PokemonProvider {
  PokemonProvider({PokeApiClient? apiClient})
    : _apiClient = apiClient ?? PokeApiClient();

  final PokeApiClient _apiClient;
  final Random _random = Random();

  Future<List<PokemonModel>> fetchRandomPokemons(int count) async {
    final ids = <int>{};
    while (ids.length < count) {
      ids.add(_random.nextInt(1025) + 1);
    }

    final futures = ids.map(fetchPokemon).toList();
    return Future.wait(futures);
  }

  Future<PokemonModel> fetchPokemon(int id) async {
    final data = await _apiClient.getJson('/pokemon/$id');
    final species = await _apiClient.getJson('/pokemon-species/$id');

    final japaneseName = _extractJapaneseName(species);
    return PokemonModel.fromJson(data).copyWith(nameJa: japaneseName);
  }

  String _extractJapaneseName(Map<String, dynamic> species) {
    final names = species['names'] as List<dynamic>?;
    if (names == null || names.isEmpty) {
      return species['name'] as String? ?? 'unknown';
    }

    String? findByLanguage(String languageCode) {
      for (final entry in names) {
        final item = entry as Map<String, dynamic>;
        final language = item['language'] as Map<String, dynamic>?;
        final code = language?['name'] as String?;
        if (code == languageCode) {
          return item['name'] as String?;
        }
      }
      return null;
    }

    return findByLanguage('ja-Hrkt') ??
        findByLanguage('ja') ??
        (species['name'] as String? ?? 'unknown');
  }
}
