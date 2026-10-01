import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-06 Penugasan — stepper 2 langkah, tanpa Pilih Driver/Kendaraan, tanpa tolak.
class PenugasanScreen extends StatelessWidget {
  /// Trip yang ditampilkan; default tugas terdekat pertama.
  final TripSummary? trip;
  const PenugasanScreen({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    final t = trip ?? MockData.tugasTerdekat.first;
    return Scaffold(
      appBar: const NavagoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Penugasan driver & kendaraan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            const TripStepper(current: 0),
            const SizedBox(height: 14),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Informasi trip', style: Theme.of(context).textTheme.titleMedium)),
                      StatusBadge(label: t.tipe, textColor: AppColors.primaryText, bgColor: AppColors.primary100),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(t.id, style: Theme.of(context).textTheme.labelSmall),
                  const Divider(height: 20),
                  _TripRow(icon: Icons.location_on_outlined, label: 'Rute', value: t.rute),
                  _TripRow(icon: Icons.calendar_today_outlined, label: 'Tanggal', value: t.tanggal),
                  _TripRow(icon: Icons.access_time_outlined, label: 'Waktu', value: t.waktu),
                  _TripRow(icon: Icons.group_outlined, label: 'Penumpang', value: t.penumpang),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Driver ditugaskan', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person_outline)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MockData.driverName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                            Text('4.8 (128 ulasan)', style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                      StatusBadge(label: 'Aktif', textColor: AppColors.successText, bgColor: AppColors.successBg),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Kendaraan ditugaskan', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 52, height: 40,
                        decoration: BoxDecoration(color: AppColors.neutral100, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.directions_bus_outlined, color: AppColors.neutral400),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.plat, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                            Text(t.kendaraan, style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                      StatusBadge(label: 'Tersedia', textColor: AppColors.successText, bgColor: AppColors.successBg),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // PRD: driver & kendaraan tampil sebagai info saja (catatan dev).
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Penugasan dikonfirmasi')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Konfirmasi Penugasan'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18)],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text('Tidak ada opsi menolak di aplikasi. Hubungi admin bila berhalangan.',
              style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: child,
    );
  }
}

class _TripRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _TripRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary600),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 96, maxWidth: 140),
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700) ?? const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
