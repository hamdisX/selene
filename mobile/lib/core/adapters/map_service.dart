import 'package:flutter/widgets.dart';

// Abstractions géographiques minimales
class LatLng {
  final double latitude;
  final double longitude;
  const LatLng(this.latitude, this.longitude);
}

class LatLngBounds {
  final LatLng southwest;
  final LatLng northeast;
  const LatLngBounds({required this.southwest, required this.northeast});
}

enum TransportMode { walk, bike, car }

// Contrat abstrait — le code métier n'importe jamais MapLibre ou Mapbox directement
abstract class MapService {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> fetchActivitiesInBounds(LatLngBounds bounds);
  Future<Map<String, dynamic>> getIsochrone(
    LatLng origin,
    int minutes,
    TransportMode mode,
  );
  void updateUserPosition(LatLng position);
  Widget buildMapWidget();
  void dispose();
}

// Sélection selon MAP_DRIVER (injecté via --dart-define)
MapService createMapService() {
  const driver = String.fromEnvironment('MAP_DRIVER', defaultValue: 'maplibre');
  if (driver == 'mapbox') {
    return MapboxMapService();
  }
  return MapLibreMapService();
}

// ─── Implémentation MapLibre (gratuit, OpenStreetMap) ────────────────────
class MapLibreMapService implements MapService {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<Map<String, dynamic>>> fetchActivitiesInBounds(
    LatLngBounds bounds,
  ) async => [];

  @override
  Future<Map<String, dynamic>> getIsochrone(
    LatLng origin,
    int minutes,
    TransportMode mode,
  ) async => {};

  @override
  void updateUserPosition(LatLng position) {}

  @override
  Widget buildMapWidget() => const SizedBox.shrink();

  @override
  void dispose() {}
}

// ─── Implémentation Mapbox (free tier 50K loads/mois) ────────────────────
class MapboxMapService implements MapService {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<Map<String, dynamic>>> fetchActivitiesInBounds(
    LatLngBounds bounds,
  ) async => [];

  @override
  Future<Map<String, dynamic>> getIsochrone(
    LatLng origin,
    int minutes,
    TransportMode mode,
  ) async => {};

  @override
  void updateUserPosition(LatLng position) {}

  @override
  Widget buildMapWidget() => const SizedBox.shrink();

  @override
  void dispose() {}
}
