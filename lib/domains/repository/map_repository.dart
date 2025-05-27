import 'package:flutter/material.dart';

import '../data_source/remote/dio/dio_map.dart';

class MapRepository {
  final DioMap _dioMap;

  MapRepository(this._dioMap);

  Future<List<dynamic>> searchLocation(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _dioMap.searchLocation(query);
    } catch (e) {
      debugPrint('MapRepository error: $e');
      return [];
    }
  }
}