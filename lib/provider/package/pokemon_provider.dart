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
    return PokemonModel.fromJson(data);
  }
}
