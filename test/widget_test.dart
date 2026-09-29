// Smoke test UI-only NavaGo.
import 'package:flutter_test/flutter_test.dart';
import 'package:navago/main.dart';

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
}
