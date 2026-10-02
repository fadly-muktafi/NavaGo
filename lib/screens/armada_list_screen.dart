import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';
import 'armada_detail_screen.dart';

/// US-02 Daftar Armada — seluruh armada, read-only.
class ArmadaListScreen extends StatefulWidget {
  const ArmadaListScreen({super.key});
  @override
  State<ArmadaListScreen> createState() => _ArmadaListScreenState();
}

class _ArmadaListScreenState extends State<ArmadaListScreen>
    with SingleTickerProviderStateMixin {
  int filter = 0;
  String query = '';
  final _searchController = TextEditingController();
  static const filters = ['Semua', 'Tersedia', 'On Trip', 'Maintenance'];

  /// Entrance stagger satu-kali (maksimal 5 item mock). Ganti filter tidak
  /// memutar ulang: setelah selesai, item dirender statis.
  late final AnimationController _enter;
  bool _enterDone = false;
  static const _stepMs = 50;
  static const _baseMs = 300;
  static const _totalMs = _baseMs + _stepMs * 4;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          setState(() => _enterDone = true);
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1.0;
      _enterDone = true;
    } else if (_enter.status == AnimationStatus.dismissed) {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _enter.dispose();
    super.dispose();
  }

  Widget _enterItem(int index, Widget child) {
    if (_enterDone) return child;
    final fade = CurvedAnimation(
      parent: _enter,
      curve: Interval(
        index * _stepMs / _totalMs,
        (index * _stepMs + _baseMs) / _totalMs,
        curve: kEaseOut,
      ),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(fade);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  List<Vehicle> get shown {
    return MockData.vehicles.where((v) {
      final matchFilter = filter == 0 ||
          (filter == 1 && v.status == VehicleStatus.tersedia) ||
          (filter == 2 && v.status == VehicleStatus.onTrip) ||
          (filter == 3 && v.status == VehicleStatus.maintenance);
      final q = query.toLowerCase();
      final matchQuery = q.isEmpty ||
          v.plat.toLowerCase().contains(q) ||
          v.tipe.toLowerCase().contains(q) ||
          v.lokasi.toLowerCase().contains(q);
      return matchFilter && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = shown;
    return Scaffold(
      appBar: const NavagoAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Daftar armada',
                        style: Theme.of(context).textTheme.titleLarge)),
                Text('${MockData.vehicles.length} armada',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            NavagoSearch(
                hint: 'Cari plat nomor, tipe, atau lokasi...',
                controller: _searchController,
                onChanged: (v) => setState(() => query = v)),
            const SizedBox(height: 12),
            FilterChips(
                labels: filters,
                selected: filter,
                onSelected: (i) => setState(() => filter = i)),
            const SizedBox(height: 12),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_outlined,
                              size: 40, color: AppColors.neutral400),
                          const SizedBox(height: 8),
                          Text(
                            query.isEmpty
                                ? 'Belum ada armada pada filter ini.'
                                : 'Tidak ada hasil untuk "$query".',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(64, 44),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                filter = 0;
                                query = '';
                              });
                            },
                            child: const Text('Hapus filter'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final v = list[i];
                        return _enterItem(
                          i,
                          VehicleListItem(
                            key: ValueKey(v.plat),
                            plat: v.plat,
                            tipe: v.tipe,
                            kapasitas: v.kapasitas,
                            lokasi: v.lokasi,
                            statusLabel: v.status.label,
                            statusFg: v.status.textColor,
                            statusBg: v.status.bgColor,
                            onTap: () {
                              // Reduce-motion: matikan transisi rute + Hero.
                              if (MediaQuery.disableAnimationsOf(context)) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        ArmadaDetailScreen(vehicle: v),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ArmadaDetailScreen(vehicle: v),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
