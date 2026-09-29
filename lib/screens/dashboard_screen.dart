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
                      Text('Halo,', style: textTheme.bodyMedium?.copyWith(color: AppColors.neutral600)),
                      Text(MockData.driverName, style: textTheme.titleLarge),
                    ],
                  ),
                ),
                Text(MockData.greetingDate, style: textTheme.labelSmall),
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
                        Text('Operasional hari ini', style: Theme.of(context).textTheme.bodySmall),
                        SizedBox(height: 2),
                        Text('Berjalan dengan baik!', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.navy900)),
                      ],
                    ),
                  ),
                  Icon(Icons.trending_up, color: AppColors.primary600, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 340;
                return GridView.count(
                  crossAxisCount: narrow ? 1 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: narrow ? 3.2 : 1.65,
                  children: const [
                    KpiCard(icon: Icons.directions_bus, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Total armada', value: MockData.kpiTotalArmada),
                    KpiCard(icon: Icons.check_circle_outline, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Armada tersedia', value: MockData.kpiTersedia),
                    KpiCard(icon: Icons.directions_car_outlined, iconColor: AppColors.warning, iconBg: AppColors.warningBg, label: 'On trip', value: MockData.kpiOnTrip),
                    KpiCard(icon: Icons.build_outlined, iconColor: AppColors.danger, iconBg: AppColors.dangerBg, label: 'Maintenance', value: MockData.kpiMaintenance, valueColor: AppColors.danger),
                    KpiCard(icon: Icons.person_outline, iconColor: AppColors.primary600, iconBg: AppColors.primary100, label: 'Driver aktif', value: MockData.kpiDriverAktif),
                    KpiCard(icon: Icons.description_outlined, iconColor: AppColors.danger, iconBg: AppColors.dangerBg, label: 'Dokumen jatuh tempo', value: MockData.kpiDokJatuhTempo, valueColor: AppColors.danger),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            // PRD: Menu Cepat dihapus. Navigasi via bottom nav (catatan dev, tidak dirender).
          ],
        ),
      ),
    );
  }
}
