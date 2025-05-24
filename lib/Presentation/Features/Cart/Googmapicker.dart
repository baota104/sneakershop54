import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({Key? key}) : super(key: key);

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  List<dynamic> _suggestions = [];
  LatLng _currentCenter = LatLng(10.762622, 106.660172); // Default location (HCMC)
  String? _selectedAddress;

  Future<void> _autocomplete(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1');

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'flutter_map_app/1.0 (your@email.com)',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _suggestions = json.decode(response.body);
      });
    } else {
      setState(() => _suggestions = []);
      debugPrint('Nominatim error: ${response.statusCode}');
    }
  }

  void _selectSuggestion(dynamic suggestion) {
    final lat = double.parse(suggestion['lat']);
    final lon = double.parse(suggestion['lon']);
    final address = suggestion['display_name'];

    setState(() {
      _currentCenter = LatLng(lat, lon);
      _selectedAddress = address;
      _searchController.text = address;
      _suggestions.clear();
      _mapController.move(_currentCenter, 15.0);
    });
  }

  void _confirmSelection() {
    if (_selectedAddress != null) {
      Navigator.pop(context, _selectedAddress);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an address.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // KHÔNG đẩy layout lên khi bàn phím hiện
      appBar: AppBar(
        title: Text('Select Address', style: GoogleFonts.raleway()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.raleway(),
                decoration: InputDecoration(
                  hintText: 'Search for a location...',
                  hintStyle: GoogleFonts.raleway(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: _autocomplete,
              ),
            ),
            if (_suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final s = _suggestions[index];
                    return ListTile(
                      title: Text(s['display_name'], style: GoogleFonts.raleway()),
                      onTap: () => _selectSuggestion(s),
                    );
                  },
                ),
              ),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentCenter,
                        child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _confirmSelection,
                icon: const Icon(Icons.check_circle),
                label: Text('Confirm Address', style: GoogleFonts.raleway(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
