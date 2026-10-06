import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Geometri rute Jakarta → Bandung dkk. via OSRM public demo
/// (gratis, tanpa API key — patuhi batas pemakaian wajar).
///
/// `http.Client` injectable agar bisa di-test dengan mock.
/// Gagal/offline → [fallbackStraight] (garis lurus): peta tetap tampil.
class RouteService {
  final http.Client? _client;
  const RouteService({http.Client? client}) : _client = client;

  /// Rute jalan raya [origin] → [destination] sebagai daftar titik.
  /// geometries=geojson → koordinat [lng, lat] langsung, tanpa decode.
  /// `live=false` berarti fallback garis lurus (offline/gagal).
  Future<({List<LatLng> points, bool live})> fetchRoute(
      LatLng origin, LatLng destination) async {
    final client = _client ?? http.Client();
    try {
      final uri = Uri.https('router.project-osrm.org', '/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}', {
        'overview': 'full',
        'geometries': 'geojson',
      });
      final res = await client.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        return (points: fallbackStraight(origin, destination), live: false);
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['code'] != 'Ok') {
        return (points: fallbackStraight(origin, destination), live: false);
      }
      final coords = (((body['routes'] as List).first
          as Map<String, dynamic>)['geometry']['coordinates'] as List);
      final points = [
        for (final c in coords)
          LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
      ];
      if (points.isEmpty) {
        return (points: fallbackStraight(origin, destination), live: false);
      }
      return (points: points, live: true);
    } catch (_) {
      return (points: fallbackStraight(origin, destination), live: false);
    } finally {
      if (_client == null) client.close();
    }
  }

  /// Garis lurus 16 titik — fallback offline/gagal.
  static List<LatLng> fallbackStraight(LatLng origin, LatLng destination) {
    const n = 15;
    return [
      for (int i = 0; i <= n; i++)
        LatLng(
          origin.latitude + (destination.latitude - origin.latitude) * i / n,
          origin.longitude + (destination.longitude - origin.longitude) * i / n,
        ),
    ];
  }
}
