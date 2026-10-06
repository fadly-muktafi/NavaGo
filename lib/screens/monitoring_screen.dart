import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/sequential_fade.dart';
import '../widgets/trip_map_view.dart';
import '../widgets/navago_app_bar.dart';

/// US-07 Monitoring — peta live perjalanan driver + ringkasan global.
class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});
  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  static const _jakarta = LatLng(-6.2088, 106.8456);
  static const _bandung = LatLng(-6.9175, 107.6191);

  int tab = 0;
  static const tabs = ['Peta', 'Armada', 'Driver', 'Peringatan'];
  final _scrollController = ScrollController();
  final _locationService = const LocationService();

  /// Stream posisi live; null = belum ada izin (pakai posisi mock).
  /// Dibuat sekali saat tab Peta pertama dibuka — bukan saat app start.
  /// asBroadcastStream SEKALI di sini (bukan di widget): stream GPS
  /// single-subscription didengar 2 StreamBuilder + di-listen ulang tiap
  /// remount tab — tanpa ini: "Bad state: Stream has already been listened".
  Stream<LatLng>? _liveStream;
  bool _locationAsked = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() => tab = i);
    // Scroll reset menyusul di onSwapped: tepat saat konten baru muncul,
    // bukan saat konten lama masih fade-out.
    if (i == 0) _ensureLocation();
  }

  Future<void> _ensureLocation() async {
    if (_locationAsked) return;
    _locationAsked = true;
    final state = await _locationService.requestPermission();
    if (!mounted) return;
    if (state == LocationState.granted) {
      setState(() {
        _liveStream = _locationService
            .positionStream()
            .map((p) => LatLng(p.latitude, p.longitude))
            .asBroadcastStream();
      });
    }
    // Ditolak/unavailable: tetap null → TripMapView pakai posisi mock.
  }

  void _resetScroll() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavagoAppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Monitoring status',
                        style: Theme.of(context).textTheme.titleLarge)),
                // Guard gutter: judul penuh tak menempel pill Live.
                const SizedBox(width: 8),
                Container(
                  padding: kPillPadding,
                  decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle,
                          size: 8, color: AppColors.primaryText),
                      const SizedBox(width: 4),
                      Text('Live',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilterChips(labels: tabs, selected: tab, onSelected: _selectTab),
            const SizedBox(height: 12),
            // Ganti tab fade berurutan (out habis → swap → in);
            // reduce-motion dibaca sendiri oleh SequentialFade.
            SequentialFade(
              onSwapped: _resetScroll,
              child: Builder(
                key: ValueKey(tab),
                builder: (context) {
                  if (tab == 0) {
                    return Column(
                      key: const ValueKey('peta'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TripMapView(
                          origin: _jakarta,
                          destination: _bandung,
                          originLabel: 'Jakarta',
                          destinationLabel: 'Bandung',
                          infoText: 'B 1234 KLM • 70 km/jam • Menuju Bandung',
                          livePosition: _liveStream,
                          onEnableLocation: _ensureLocation,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _SummaryCard(
                                    icon: Icons.directions_bus_outlined,
                                    label: 'Armada Aktif',
                                    value: '15',
                                    total: 'dari 48')),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _SummaryCard(
                                    icon: Icons.person_outline,
                                    label: 'Driver Aktif',
                                    value: '42',
                                    total: 'dari 50')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SectionHeader(
                            title: 'Peringatan penting', onSeeAll: null),
                        const SizedBox(height: 12),
                        const _Alert(
                            icon: Icons.warning_amber_rounded,
                            iconColor: AppColors.dangerText,
                            iconBg: AppColors.dangerBg,
                            title: '3 Armada perlu maintenance',
                            desc: 'Service berkala dalam 3 hari ke depan'),
                        const SizedBox(height: 12),
                        const _Alert(
                            icon: Icons.description,
                            iconColor: AppColors.warningText,
                            iconBg: AppColors.warningBg,
                            title: '2 Dokumen hampir habis',
                            desc: 'STNK dan Asuransi akan segera jatuh tempo'),
                        const SizedBox(height: 12),
                        const _Alert(
                            icon: Icons.person_off,
                            iconColor: AppColors.infoText,
                            iconBg: AppColors.infoBg,
                            title: '1 Driver tidak tersedia',
                            desc: 'Belum ada penugasan untuk shift besok'),
                      ],
                    );
                  }
                  return Container(
                    key: ValueKey('lainnya-$tab'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutral200),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.construction_outlined,
                            size: 40, color: AppColors.neutral400),
                        const SizedBox(height: 8),
                        Text(
                          'Belum ada data untuk tab ini.\nKonten menyusul.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String total;
  const _SummaryCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded + ellipsis: label tak meluap di kartu 138px saat
          // font-scale besar.
          Row(children: [
            Icon(icon, size: 18, color: AppColors.primary600),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
          ]),
          // Sama seperti KpiCard: pasangan label–angka selalu 2px.
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  )),
              const SizedBox(width: 4),
              Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(total,
                      style: Theme.of(context).textTheme.labelSmall)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String desc;
  const _Alert(
      {required this.icon,
      required this.iconColor,
      required this.iconBg,
      required this.title,
      required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          // Pola baku swap ikon: crossfade opacity 150ms (bukan gerak).
          // Aktif saat data live masuk; reduce-motion = instan.
          AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 150),
            switchInCurve: kEaseOut,
            switchOutCurve: kEaseOut,
            child: Container(
              key: ValueKey(icon),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(desc, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
