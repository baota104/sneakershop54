import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../domains/repository/map_repository.dart';


class MapProvider with ChangeNotifier {
  final MapRepository _mapRepository;
  MapProvider(this._mapRepository);

  // State
  List<dynamic> _suggestions = [];
  LatLng _currentLocation = const LatLng(10.762622, 106.660172);
  String? _selectedAddress;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<dynamic> get suggestions => _suggestions;
  LatLng get currentLocation => _currentLocation;
  String? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Actions
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _suggestions = await _mapRepository.searchLocation(query);
    } catch (e) {
      _error = 'Failed to search locations: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLocation(dynamic suggestion) {
    final lat = double.parse(suggestion['lat']);
    final lon = double.parse(suggestion['lon']);

    _currentLocation = LatLng(lat, lon);
    _selectedAddress = suggestion['display_name'];
    _suggestions = [];
    notifyListeners();
  }

  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }
}