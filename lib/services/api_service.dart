import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<Map<String, dynamic>> fetchPokemonPage({required int offset, required int limit}) async {
    final response = await _dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {'offset': offset, 'limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }
}