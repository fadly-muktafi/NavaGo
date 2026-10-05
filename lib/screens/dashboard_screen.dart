import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-01 Dashboard Operasional (Driver) — tanpa Menu Cepat.
class DashboardScreen extends StatefulWidget {
  final ValueChanged<TripSummary>? onOpenPenugasan;
  const DashboardScreen({super.key, this.onOpenPenugasan});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  /// Entrance stagger satu-kali (state dijaga IndexedStack sehingga tidak
  /// terputar ulang saat kembali dari tab lain). Dihormati bila user
  /// mengaktifkan reduce-motion via MediaQuery.disableAnimations.
  late final AnimationController _enter;
  late final List<Animation<double>> _fade;
  late final List<Animation<Offset>> _slide;

  static const _stepMs = 50;
  static const _baseMs = 250;
  static const _totalMs = _baseMs + _stepMs * 5;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );
    _fade = List.generate(
      6,
      (i) => CurvedAnimation(
        parent: _enter,
        curve: Interval(
          i * _stepMs / _totalMs,
          (i * _stepMs + _baseMs) / _totalMs,
          curve: kEaseOut,
        ),
      ),
    );
    _slide = List.generate(
      6,
      (i) => Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _enter,
        curve: Interval(
          i * _stepMs / _totalMs,
          (i * _stepMs + _baseMs) / _totalMs,
          curve: kEaseOut,
        ),
      )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduce-motion: lewati entrance, langsung ke keadaan akhir.
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1.0;
    } else if (_enter.status == AnimationStatus.dismissed) {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  /// Satu kartu entrance: fade + naik ~10px, mengikuti slot stagger-nya.
  Widget _enterCard(int index, Widget child) {
    return FadeTransition(
      opacity: _fade[index],
      child: SlideTransition(position: _slide[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const NavagoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo,',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.neutral600)),
                      Text(MockData.driverName, style: textTheme.titleLarge),
                    ],
                  ),
                ),
                // Align kanan-atas: mengunci ke edge, sejajar baris 'Halo,'.
                // Guard gutter 8: nama penuh tak menempel tanggal.
                const SizedBox(width: 8),
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Tooltip(
                      message: MockData.greetingDate,
                      child: Text(MockData.greetingDate,
                          style: textTheme.labelSmall,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Banner status operasional
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary100, AppColors.primary50],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Operasional hari ini',
                            style: Theme.of(context).textTheme.bodySmall),
                        SizedBox(height: 2),
                        Text('Berjalan dengan baik!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.navy900)),
                      ],
                    ),
                  ),
                  // Nudge optik: ikon 32px vs blok dua baris teks (~34px)
                  // terlihat turun bila center geometris — angkat 2px.
                  Transform.translate(
                    offset: const Offset(0, -2),
                    child: const Icon(Icons.trending_up,
                        color: AppColors.primary600, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < kGridNarrowBreakpoint;
                final cards = [
                  _enterCard(
                      0,
                      const KpiCard(
                          icon: Icons.directions_bus,
                          iconColor: AppColors.primary600,
                          iconBg: AppColors.primary100,
                          label: 'Total Armada',
                          value: MockData.kpiTotalArmada)),
                  _enterCard(
                      1,
                      const KpiCard(
                          icon: Icons.check_circle,
                          iconColor: AppColors.primary600,
                          iconBg: AppColors.primary100,
                          label: 'Armada Ready',
                          value: MockData.kpiTersedia)),
                  _enterCard(
                      2,
                      const KpiCard(
                          icon: Icons.directions_car,
                          iconColor: AppColors.warningText,
                          iconBg: AppColors.warningBg,
                          label: 'On Trip',
                          value: MockData.kpiOnTrip)),
                  _enterCard(
                      3,
                      const KpiCard(
                          icon: Icons.build,
                          iconColor: AppColors.danger,
                          iconBg: AppColors.dangerBg,
                          label: 'Maintenance',
                          value: MockData.kpiMaintenance,
                          valueColor: AppColors.danger)),
                  _enterCard(
                      4,
                      const KpiCard(
                          icon: Icons.person,
                          iconColor: AppColors.primary600,
                          iconBg: AppColors.primary100,
                          label: 'Driver Aktif',
                          value: MockData.kpiDriverAktif)),
                  _enterCard(
                      5,
                      const KpiCard(
                          icon: Icons.description,
                          iconColor: AppColors.danger,
                          iconBg: AppColors.dangerBg,
                          label: 'Jatuh Tempo',
                          value: MockData.kpiDokJatuhTempo,
                          valueColor: AppColors.danger)),
                ];
                // Tinggi baris = tinggi kartu tertinggi (pas membungkus isi),
                // bukan dari rasio aspek — tidak ada space kosong sisa.
                if (narrow) {
                  return Column(
                    children: [
                      for (int i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        cards[i],
                      ],
                    ],
                  );
                }
                return Column(
                  children: [
                    for (int r = 0; r < 3; r++) ...[
                      if (r > 0) const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cards[r * 2]),
                          const SizedBox(width: 12),
                          Expanded(child: cards[r * 2 + 1]),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (MockData.tugasTerdekat.isNotEmpty) ...[
              SectionHeader(
                title: 'Tugas berikutnya',
                onSeeAll: null,
              ),
              const SizedBox(height: 8),
              for (int i = 0; i < MockData.tugasTerdekat.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                TugasBerikutnyaCard(
                  trip: MockData.tugasTerdekat[i],
                  onTap: widget.onOpenPenugasan == null
                      ? null
                      : () =>
                          widget.onOpenPenugasan!(MockData.tugasTerdekat[i]),
                ),
              ],
            ],
            const SizedBox(height: 8),
            // PRD: Menu Cepat dihapus. Navigasi via bottom nav (catatan dev, tidak dirender).
          ],
        ),
      ),
    );
  }
}
