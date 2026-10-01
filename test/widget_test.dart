// Smoke test UI-only NavaGo.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navago/main.dart';
import 'package:navago/widgets/common.dart';

void main() {
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
}
