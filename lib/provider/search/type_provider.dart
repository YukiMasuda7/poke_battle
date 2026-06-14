import 'package:poke_battle/model/search/type_relation_model.dart';
import 'package:poke_battle/provider/dio/poke_api_client.dart';

class TypeProvider {
  TypeProvider({PokeApiClient? apiClient})
    : _apiClient = apiClient ?? PokeApiClient();

  final PokeApiClient _apiClient;
  final Map<String, TypeRelationModel> _cache = {};

  Future<TypeRelationModel> fetchTypeRelation(String typeName) async {
    final cached = _cache[typeName];
    if (cached != null) {
      return cached;
    }

    final data = await _apiClient.getJson('/type/$typeName');
    final relation = TypeRelationModel.fromJson(data);
    _cache[typeName] = relation;
    return relation;
  }
}
