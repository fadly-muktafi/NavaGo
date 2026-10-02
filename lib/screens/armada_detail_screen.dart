import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-03 + US-04: Detail Armada read-only + section Maintenance per kendaraan.
/// Tombol "Ajukan Maintenance" non-fungsional (form ditunda — keputusan user #4).
class ArmadaDetailScreen extends StatelessWidget {
  final Vehicle vehicle;
  const ArmadaDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    return Scaffold(
      appBar: const NavagoAppBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto hero placeholder (badge galeri disembunyikan sampai foto asli ada).
            Semantics(
              image: true,
              label: 'Foto armada Toyota Hiace B 1234 KLM',
              child: Hero(
                tag: 'vehicle-${v.plat}',
                child: Container(
                  height: kDetailHeroHeight,
                  decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                      child: Icon(Icons.directions_bus_outlined,
                          size: 64, color: AppColors.neutral400)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Text(v.plat,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 20))),
                StatusBadge(
                    label: v.status.label,
                    textColor: v.status.textColor,
                    bgColor: v.status.bgColor),
              ],
            ),
            Text('${v.tipe} Commuter',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SpecChip(icon: Icons.event_seat_outlined, label: '12 Kursi'),
                _SpecChip(
                    icon: Icons.local_gas_station_outlined, label: 'Diesel'),
                _SpecChip(icon: Icons.settings_outlined, label: 'AT'),
              ],
            ),
            const SizedBox(height: 12),
            // Info tile 2x2 — baris membungkus isi (tanpa kunci rasio aspek).
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const cells = [
                    _InfoCell(
                        icon: Icons.location_on_outlined,
                        label: 'Lokasi saat ini',
                        value: 'Jakarta Pusat'),
                    _InfoCell(
                        icon: Icons.payments_outlined,
                        label: 'Tarif sewa',
                        value: 'Rp 1.200.000 / hari'),
                    _InfoCell(
                        icon: Icons.speed_outlined,
                        label: 'Kilometer',
                        value: '125.430 km'),
                    _InfoCell(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tahun',
                        value: '2020'),
                  ];
                  if (constraints.maxWidth < kInfoTileNarrowBreakpoint) {
                    return Column(
                      children: [
                        for (int i = 0; i < cells.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          cells[i],
                        ],
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cells[0]),
                          SizedBox(width: 12),
                          Expanded(child: cells[1]),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cells[2]),
                          SizedBox(width: 12),
                          Expanded(child: cells[3]),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
                'Toyota Hiace Commuter, kondisi prima, cocok untuk perjalanan dalam kota maupun luar kota.',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Ajukan Maintenance'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text('Form pengajuan segera hadir.',
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            // Section Maintenance (PRD: bagian dari Detail, tanpa kalender).
            // Stateful sendiri agar ganti filter tidak me-rebuild seluruh halaman.
            const _MaintenanceSection(),
          ],
        ),
      ),
    );
  }
}

/// Section Maintenance per kendaraan: state filter hidup di sini agar
/// setState-nya sekecil datanya (hero, spec, info-tile tidak ikut rebuild).
class _MaintenanceSection extends StatefulWidget {
  const _MaintenanceSection();

  @override
  State<_MaintenanceSection> createState() => _MaintenanceSectionState();
}

class _MaintenanceSectionState extends State<_MaintenanceSection> {
  int catFilter = 0;
  static const cats = ['Semua', 'Service', 'Dokumen', 'Lainnya'];

  List<MaintenanceItemData> get maintShown {
    return MockData.maintenances.where((m) {
      if (catFilter == 0) return true;
      if (catFilter == 1) return m.kind == MaintenanceKind.service;
      if (catFilter == 2) return m.kind == MaintenanceKind.dokumen;
      return m.kind == MaintenanceKind.lainnya;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Maintenance kendaraan ini',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        FilterChips(
            labels: cats,
            selected: catFilter,
            onSelected: (i) => setState(() => catFilter = i)),
        const SizedBox(height: 12),
        // Ganti filter di-crossfade (filter-nya sendiri tetap instan).
        AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 200),
          switchInCurve: kEaseOut,
          switchOutCurve: kEaseOut,
          child: Column(
            key: ValueKey(catFilter),
            children: [
              for (final m in maintShown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MaintenanceListItem(
                    icon: m.judul.contains('Oli')
                        ? Icons.opacity
                        : m.judul.contains('Service')
                            ? Icons.build
                            : m.judul.contains('KIR')
                                ? Icons.fact_check
                                : Icons.shield,
                    iconColor: dueColorsFor(m.daysLeft).fg,
                    iconBg: dueColorsFor(m.daysLeft).bg,
                    judul: m.judul,
                    subjudul: m.subjudul,
                    tanggal: m.tanggal,
                    sisa: m.sisa,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.neutral600),
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
      backgroundColor: AppColors.neutral100,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoCell(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: AppColors.primary600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 2),
              Tooltip(
                message: value,
                child: Text(value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
