// Regression test: FilterChips tidak boleh overflow (kotak kuning-hitam)
// pada lebar layar ponsel, untuk semua set label yang dipakai aplikasi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:navago/widgets/common.dart';

Future<void> _pumpChips(WidgetTester tester, double width, List<String> labels) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: FilterChips(labels: labels, selected: 0, onSelected: (_) {}),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const sets = [
    ['Semua', 'Tersedia', 'On Trip', 'Maintenance'],
    ['Semua', 'Service', 'Dokumen', 'Lainnya'],
    ['Peta', 'Armada', 'Driver', 'Peringatan'],
    ['Informasi', 'Dokumen', 'Riwayat Trip'],
  ];

  for (final w in [360.0, 320.0]) {
    testWidgets('FilterChips muat tanpa overflow pada lebar $w', (tester) async {
      for (final labels in sets) {
        await _pumpChips(tester, w, labels);
        // RenderFlex overflowed tercatat sebagai FlutterError ->
        // menggagalkan test ini secara otomatis.
        expect(tester.takeException(), isNull);
      }
    });
  }
}
