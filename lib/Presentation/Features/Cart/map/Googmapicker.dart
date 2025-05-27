import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../domains/data_source/remote/dio/dio_map.dart';
import '../../../../domains/repository/map_repository.dart';
import 'map_provider.dart';


class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({Key? key}) : super(key: key);

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DioMap()),
        Provider(create: (context) => MapRepository(context.read<DioMap>())),
        ChangeNotifierProxyProvider<MapRepository, MapProvider>(
          create: (context) => MapProvider(context.read<MapRepository>()),
          update: (context, repository, provider) =>
          provider ?? MapProvider(repository),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Select Address', style: GoogleFonts.raleway()),
        ),
        body: Consumer<MapProvider>(
          builder: (context, mapProvider, child) {
            // Di chuyển bản đồ khi vị trí thay đổi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mapProvider.currentLocation != _mapController) {
                _mapController.move(mapProvider.currentLocation, 15.0);
              }
            });

            return SafeArea(
              child: Column(
                children: [
                  _buildSearchField(context, mapProvider),
                  if (mapProvider.isLoading)
                    const LinearProgressIndicator(),
                  if (mapProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mapProvider.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (mapProvider.suggestions.isNotEmpty)
                    _buildSuggestionsList(mapProvider),
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: mapProvider.currentLocation,
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
                              point: mapProvider.currentLocation,
                              child: const Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildConfirmButton(mapProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, MapProvider mapProvider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.raleway(),
        decoration: InputDecoration(
          hintText: 'Search for a location...',
          hintStyle: GoogleFonts.raleway(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              mapProvider.clearSuggestions();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: mapProvider.searchLocation,
      ),
    );
  }

  Widget _buildSuggestionsList(MapProvider mapProvider) {
    return Container(
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
        itemCount: mapProvider.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = mapProvider.suggestions[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(
              suggestion['display_name'],
              style: GoogleFonts.raleway(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              _searchController.text = suggestion['display_name'];
              mapProvider.selectLocation(suggestion);
            },
          );
        },
      ),
    );
  }

  Widget _buildConfirmButton(MapProvider mapProvider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        onPressed: () {
          if (mapProvider.selectedAddress != null) {
            Navigator.pop(context, mapProvider.selectedAddress);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select an address.")),
            );
          }
        },
        icon: const Icon(Icons.check_circle),
        label: Text(
          'Confirm Address',
          style: GoogleFonts.raleway(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}