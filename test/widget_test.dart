// Smoke test UI-only NavaGo.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navago/main.dart';
import 'package:navago/widgets/common.dart';

/// Muat font asli (bukan Ahem) agar pengukuran layout di test = device.
/// Ahem melebar-kan tiap karakter 2x — semua "overflow" jadi palsu.
Future<void> _loadRealFonts() async {
  final families = {
    'PlusJakartaSans': [
      'fonts/PlusJakartaSans-Regular.ttf',
      'fonts/PlusJakartaSans-Medium.ttf',
      'fonts/PlusJakartaSans-SemiBold.ttf',
      'fonts/PlusJakartaSans-Bold.ttf',
      'fonts/PlusJakartaSans-ExtraBold.ttf',
    ],
    'Roboto': [
      'fonts/PlusJakartaSans-Regular.ttf',
      'fonts/PlusJakartaSans-Medium.ttf',
      'fonts/PlusJakartaSans-SemiBold.ttf',
      'fonts/PlusJakartaSans-Bold.ttf',
      'fonts/PlusJakartaSans-ExtraBold.ttf',
    ],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(Future(() async =>
          ByteData.view(File(path).readAsBytesSync().buffer)));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(_loadRealFonts);

  testWidgets('App boots with 5 bottom nav tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const NavagoApp());
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Armada'), findsWidgets);
    expect(find.text('Penugasan'), findsOneWidget);
    expect(find.text('Monitoring'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Beranda menampilkan 3 tugas teratas dan ketuk membuka trip yang benar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NavagoApp());
    await tester.pumpAndSettle();

    expect(find.text('Tugas berikutnya'), findsOneWidget);
    expect(find.byType(TugasBerikutnyaCard), findsNWidgets(3));

    await tester.scrollUntilVisible(
      find.text('Jakarta → Bogor'),
      200,
    );
    await tester.tap(find.text('Jakarta → Bogor'));
    await tester.pumpAndSettle();

    expect(find.text('Penugasan driver & kendaraan'), findsOneWidget);
    expect(find.text('TRP-20240516-002'), findsOneWidget);
  });

  testWidgets('Cari Armada bisa dihapus via tombol clear',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NavagoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Armada').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hiace');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.clear), findsNothing);
    expect(find.text('B 1234 KLM'), findsWidgets);
  });

  testWidgets('Tab Profile berganti dengan crossfade',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NavagoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('SIM'), findsOneWidget);

    await tester.tap(find.text('Riwayat Trip'));
    await tester.pumpAndSettle();
    expect(find.text('Jakarta → Bandung'), findsWidgets);
  });

  testWidgets('App penuh bebas overflow di 320px + font-scale 1.3',
      (WidgetTester tester) async {
    // Kondisi ekstrem (PRD: font-scale 130% tidak terpotong): kelima tab
    // diuji; RenderFlex overflowed otomatis menggagalkan test ini.
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: const NavagoApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (final tab in const ['Armada', 'Penugasan', 'Monitoring', 'Profile']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
