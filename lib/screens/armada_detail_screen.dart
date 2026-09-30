import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-03 + US-04: Detail Armada read-only + section Maintenance per kendaraan.
/// Tombol "Ajukan Maintenance" non-fungsional (form ditunda — keputusan user #4).
class ArmadaDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  const ArmadaDetailScreen({super.key, required this.vehicle});

  @override
  State<ArmadaDetailScreen> createState() => _ArmadaDetailScreenState();
}

class _ArmadaDetailScreenState extends State<ArmadaDetailScreen> {
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
    final v = widget.vehicle;
    return Scaffold(
      appBar: const NavagoAppBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto hero placeholder
            Semantics(
              image: true,
              label: 'Foto armada Toyota Hiace B 1234 KLM',
              child: Container(
                height: 190,
                decoration: BoxDecoration(color: AppColors.neutral100, borderRadius: BorderRadius.circular(16)),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.directions_bus, size: 64, color: AppColors.neutral400)),
                    Positioned(
                      right: 10, bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.neutral900.withOpacity(0.65), borderRadius: BorderRadius.circular(8)),
                        child: const Text('1/5', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(v.plat, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20))),
                StatusBadge(label: v.status.label, textColor: v.status.textColor, bgColor: v.status.bgColor),
              ],
            ),
            Text('${v.tipe} Commuter', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              children: [
                _SpecChip(icon: Icons.event_seat_outlined, label: '12 Kursi'),
                _SpecChip(icon: Icons.local_gas_station_outlined, label: 'Diesel'),
                _SpecChip(icon: Icons.settings_outlined, label: 'AT'),
              ],
            ),
            const SizedBox(height: 12),
            // Info tile 2x2
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 300;
                  return GridView.count(
                    crossAxisCount: narrow ? 1 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: narrow ? 4.5 : 2.4,
                    children: const [
                      _InfoCell(icon: Icons.location_on_outlined, label: 'Lokasi saat ini', value: 'Jakarta Pusat'),
                      _InfoCell(icon: Icons.payments_outlined, label: 'Tarif sewa', value: 'Rp 1.200.000 / hari'),
                      _InfoCell(icon: Icons.speed_outlined, label: 'Kilometer', value: '125.430 km'),
                      _InfoCell(icon: Icons.calendar_today_outlined, label: 'Tahun', value: '2020'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Toyota Hiace Commuter, kondisi prima, cocok untuk perjalanan dalam kota maupun luar kota.',
              style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Ajukan Maintenance'),
              ),
            ),
            const SizedBox(height: 6),
            Text('Form pengajuan segera hadir.',
              style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            // Section Maintenance (PRD: bagian dari Detail, tanpa kalender)
            Text('Maintenance kendaraan ini', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            // PRD: jadwal per kendaraan, tanpa kalender mingguan (catatan dev).
            const SizedBox(height: 10),
            FilterChips(labels: cats, selected: catFilter, onSelected: (i) => setState(() => catFilter = i)),
            const SizedBox(height: 10),
            ...maintShown.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MaintenanceListItem(
                icon: m.judul.contains('Oli') ? Icons.opacity_outlined
                    : m.judul.contains('Service') ? Icons.build_outlined
                    : m.judul.contains('KIR') ? Icons.fact_check_outlined
                    : Icons.shield_outlined,
                iconColor: m.sisa.startsWith('3') ? AppColors.danger
                    : m.sisa.startsWith('8') ? AppColors.warning : AppColors.info,
                iconBg: m.sisa.startsWith('3') ? AppColors.dangerBg
                    : m.sisa.startsWith('8') ? AppColors.warningBg : AppColors.infoBg,
                judul: m.judul, subjudul: m.subjudul, tanggal: m.tanggal, sisa: m.sisa,
              ),
            )),
          ],
        ),
      ),
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
      avatar: Icon(icon, size: 15, color: AppColors.neutral600),
      label: Text(label, style: const TextStyle(fontSize: 11)),
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
  const _InfoCell({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Tooltip(
                message: value,
                child: Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
