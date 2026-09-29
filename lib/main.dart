import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/navago_bottom_nav.dart';
import 'screens/dashboard_screen.dart';
import 'screens/armada_list_screen.dart';
import 'screens/penugasan_screen.dart';
import 'screens/monitoring_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const NavagoApp());
}

/// NavaGo Driver App — UI-only slicing (mock data).
/// Bottom nav PRD: Beranda · Armada · Penugasan · Monitoring · Profile.
class NavagoApp extends StatelessWidget {
  const NavagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavaGo Driver',
      debugShowCheckedModeBanner: false,
      theme: buildNavagoTheme(),
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int index = 0;

  static const _pages = [
    DashboardScreen(),
    ArmadaListScreen(),
    PenugasanScreen(),
    MonitoringScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: NavagoBottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
