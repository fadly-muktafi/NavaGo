import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-06 Penugasan — stepper 2 langkah, tanpa Pilih Driver/Kendaraan, tanpa tolak.
class PenugasanScreen extends StatelessWidget {
  const PenugasanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavagoAppBar(title: 'Penugasan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penugasan Driver & Kendaraan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const TripStepper(current: 0),
            const SizedBox(height: 14),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Informasi Trip', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                      StatusBadge(label: 'Reguler', textColor: AppColors.primary600, bgColor: AppColors.primary100),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('TRP-20240514-001', style: TextStyle(fontSize: 11, color: AppColors.neutral600)),
                  const Divider(height: 20),
                  const _TripRow(icon: Icons.location_on_outlined, label: 'Rute', value: 'Jakarta → Bandung'),
                  const _TripRow(icon: Icons.calendar_today_outlined, label: 'Tanggal', value: '15 Mei 2024'),
                  const _TripRow(icon: Icons.access_time_outlined, label: 'Waktu', value: '08:00 – 16:00 (1 Hari)'),
                  const _TripRow(icon: Icons.group_outlined, label: 'Jumlah Penumpang', value: '10 Orang'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Driver Ditugaskan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MockData.driverName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text('4.8 (128 ulasan)', style: TextStyle(fontSize: 11, color: AppColors.neutral600)),
                          ],
                        ),
                      ),
                      StatusBadge(label: 'Aktif', textColor: AppColors.success, bgColor: AppColors.successBg),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Kendaraan Ditugaskan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 52, height: 40,
                        decoration: BoxDecoration(color: AppColors.neutral100, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.directions_bus, color: AppColors.neutral400),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('B 1234 KLM', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text('Toyota Hiace • 12 Kursi', style: TextStyle(fontSize: 11, color: AppColors.neutral600)),
                          ],
                        ),
                      ),
                      StatusBadge(label: 'Tersedia', textColor: AppColors.success, bgColor: AppColors.successBg),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('PRD: driver & kendaraan tampil sebagai info saja (bukan pilihan).',
                    style: TextStyle(fontSize: 11, color: AppColors.neutral400)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Penugasan dikonfirmasi (mock) • tercatat dengan timestamp')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Konfirmasi Penugasan'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18)],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text('Tidak ada opsi menolak di aplikasi (PRD). Hubungi admin bila berhalangan.',
              style: TextStyle(fontSize: 11, color: AppColors.neutral400)),
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
        children: [
          Icon(icon, size: 18, color: AppColors.primary600),
          const SizedBox(width: 8),
          SizedBox(width: 130, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.neutral600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
