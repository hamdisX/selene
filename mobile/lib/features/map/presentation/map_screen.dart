import 'package:flutter/material.dart';
import '../../../core/adapters/map_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapService _mapService;

  @override
  void initState() {
    super.initState();
    _mapService = createMapService();
    _mapService.initialize();
  }

  @override
  void dispose() {
    _mapService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Widget carte — MapLibre ou Mapbox selon MAP_DRIVER
          _mapService.buildMapWidget(),

          // FAB créer activité — Sprint Activities
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Créer une activité'),
            ),
          ),
        ],
      ),
    );
  }
}
