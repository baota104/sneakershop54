import 'package:dio/dio.dart';

class DioMap {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://nominatim.openstreetmap.org',
    headers: {
      'User-Agent': 'flutter_map_app/1.0 (your@email.com)',
    },
  ));

  Future<List<dynamic>> searchLocation(String query) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
          'addressdetails': 1,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to search location: ${e.message}');
    }
  }
}