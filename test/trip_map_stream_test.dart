// Regression test bug layar merah Monitoring:
// "Bad state: Stream has already been listened to" saat Peta → tab lain →
// Peta. Stream GPS single-subscription didengar 2 StreamBuilder + di-listen
// ulang tiap remount — sumber WAJIB broadcast (lihat MonitoringScreen).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:navago/theme/app_theme.dart';
import 'package:navago/widgets/trip_map_view.dart';

import 'widget_test.dart' show loadRealFontsForTest;

void main() {
  setUpAll(loadRealFontsForTest);

  testWidgets('TripMapView tahan remount dengan stream broadcast',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // StreamController() = single-subscription, seperti Geolocator —
    // kontrak widget menuntut broadcast, jadi convert SEKALI di sini
    // (persis seperti MonitoringScreen._ensureLocation).
    final controller = StreamController<LatLng>();
    final broadcast = controller.stream.asBroadcastStream();
    addTearDown(controller.close);

    Widget buildMap(Key key) => MaterialApp(
          theme: buildNavagoTheme(),
          home: Scaffold(
            body: TripMapView(
              key: key,
              origin: const LatLng(-6.2088, 106.8456),
              destination: const LatLng(-6.9175, 107.6191),
              originLabel: 'Jakarta',
              destinationLabel: 'Bandung',
              infoText: 'B 1234 KLM',
              livePosition: broadcast,
            ),
          ),
        );

    await tester.pumpWidget(buildMap(const ValueKey('a')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Posisi mengalir → pill tampilkan koordinat GPS.
    controller.add(const LatLng(-6.5, 107.0));
    await tester.pumpAndSettle();
    expect(find.textContaining('GPS -6.5000'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Remount (simulasi Peta → tab lain → Peta): skenario layar merah user.
    await tester.pumpWidget(buildMap(const ValueKey('b')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    controller.add(const LatLng(-6.6, 107.1));
    await tester.pumpAndSettle();
    expect(find.textContaining('GPS -6.6000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
