import 'package:dio/dio.dart';

class PokeApiClient {
  PokeApiClient({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));

  final Dio _dio;

  Future<Map<String, dynamic>> getJson(String path) async {
    final response = await _dio.get<Map<String, dynamic>>(path);
    final data = response.data;
    if (data == null) {
      throw Exception('レスポンスが空です: $path');
    }
    return data;
  }
}
