import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-01 Dashboard Operasional (Driver) — tanpa Menu Cepat.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavagoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo,', style: TextStyle(fontSize: 14, color: AppColors.neutral600)),
                      Text(MockData.driverName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Text(MockData.greetingDate, style: const TextStyle(fontSize: 11, color: AppColors.neutral600)),
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
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Operasional Hari Ini', style: TextStyle(fontSize: 12, color: AppColors.neutral600)),
                        SizedBox(height: 2),
                        Text('Berjalan dengan Baik!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy900)),
                      ],
                    ),
                  ),
                  Icon(Icons.trending_up, color: AppColors.primary600, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: const [
                KpiCard(icon: Icons.directions_bus, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Total Armada', value: MockData.kpiTotalArmada),
                KpiCard(icon: Icons.check_circle_outline, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Armada Tersedia', value: MockData.kpiTersedia),
                KpiCard(icon: Icons.directions_car_outlined, iconColor: Colors.orange, iconBg: Color(0xFFFFF1D6), label: 'On Trip', value: MockData.kpiOnTrip),
                KpiCard(icon: Icons.build_outlined, iconColor: AppColors.danger, iconBg: AppColors.dangerBg, label: 'Maintenance', value: MockData.kpiMaintenance, valueColor: AppColors.danger),
                KpiCard(icon: Icons.person_outline, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Driver Aktif', value: MockData.kpiDriverAktif),
                KpiCard(icon: Icons.description_outlined, iconColor: AppColors.danger, iconBg: AppColors.dangerBg, label: 'Dok. Jatuh Tempo', value: MockData.kpiDokJatuhTempo, valueColor: AppColors.danger),
              ],
            ),
            const SizedBox(height: 8),
            const Text('PRD: Menu Cepat dihapus. Navigasi via bottom nav.',
              style: TextStyle(fontSize: 11, color: AppColors.neutral400)),
          ],
        ),
      ),
    );
  }
}
