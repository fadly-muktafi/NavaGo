// Test RouteService dengan mock http.Client: sukses, gagal, offline.
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:latlong2/latlong.dart';
import 'package:navago/services/route_service.dart';

const _jakarta = LatLng(-6.2088, 106.8456);
const _bandung = LatLng(-6.9175, 107.6191);

const _osrmOk = '''
{"code":"Ok","routes":[{"geometry":{"coordinates":[
[106.8456,-6.2088],[107.0,-6.5],[107.6191,-6.9175]]}}]}
''';

void main() {
  test('fetchRoute sukses mengembalikan geometri OSRM', () async {
    final service = RouteService(
      client: MockClient((_) async => http.Response(_osrmOk, 200)),
    );
    final result = await service.fetchRoute(_jakarta, _bandung);
    expect(result.live, isTrue);
    expect(result.points.length, 3);
    expect(result.points.first.latitude, closeTo(-6.2088, 0.0001));
    expect(result.points.first.longitude, closeTo(106.8456, 0.0001));
  });

  test('fetchRoute gagal → fallback garis lurus', () async {
    final service = RouteService(
      client: MockClient((_) async => http.Response('oops', 500)),
    );
    final result = await service.fetchRoute(_jakarta, _bandung);
    expect(result.live, isFalse);
    expect(result.points.length, 16);
    expect(result.points.first, _jakarta);
    expect(result.points.last, _bandung);
  });

  test('fetchRoute offline (throw) → fallback garis lurus', () async {
    final service = RouteService(
      client: MockClient((_) async => throw const SocketExceptionClosedForTest()),
    );
    final result = await service.fetchRoute(_jakarta, _bandung);
    expect(result.live, isFalse);
    expect(result.points.length, 16);
  });

  test('fallbackStraight 16 titik ujung-ke-ujung', () {
    final points = RouteService.fallbackStraight(_jakarta, _bandung);
    expect(points.length, 16);
    expect(points.first, _jakarta);
    expect(points.last, _bandung);
  });
}

class SocketExceptionClosedForTest implements Exception {
  const SocketExceptionClosedForTest();
  @override
  String toString() => 'SocketException (test)';
}
