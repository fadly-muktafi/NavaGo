import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-07 Monitoring — peta perjalanan driver sendiri (placeholder) + ringkasan global.
class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});
  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  int tab = 0;
  static const tabs = ['Peta', 'Armada', 'Driver', 'Peringatan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavagoAppBar(title: 'Monitoring Status'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Monitoring Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary100, borderRadius: BorderRadius.circular(999)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.primary600),
                      SizedBox(width: 4),
                      Text('Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilterChips(labels: tabs, selected: tab, onSelected: (i) => setState(() => tab = i)),
            const SizedBox(height: 12),
            if (tab == 0) ...[
              const MapPlaceholder(),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(child: _SummaryCard(icon: Icons.directions_bus, label: 'Armada Aktif', value: '15', total: 'dari 48')),
                  SizedBox(width: 12),
                  Expanded(child: _SummaryCard(icon: Icons.person_outline, label: 'Driver Aktif', value: '42', total: 'dari 50')),
                ],
              ),
              const SizedBox(height: 14),
              SectionHeader(title: 'Peringatan Penting', onSeeAll: null),
              const SizedBox(height: 8),
              const _Alert(icon: Icons.warning_amber_rounded, iconColor: AppColors.danger, iconBg: AppColors.dangerBg, title: '3 Armada perlu maintenance', desc: 'Service berkala dalam 3 hari ke depan'),
              const SizedBox(height: 8),
              const _Alert(icon: Icons.description_outlined, iconColor: AppColors.warning, iconBg: AppColors.warningBg, title: '2 Dokumen hampir habis', desc: 'STNK dan Asuransi akan segera jatuh tempo'),
              const SizedBox(height: 8),
              const _Alert(icon: Icons.person_off_outlined, iconColor: AppColors.info, iconBg: AppColors.infoBg, title: '1 Driver tidak tersedia', desc: 'Belum ada penugasan untuk shift besok'),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Text(
                  'Tab "${tabs[tab]}" untuk driver — isi detail TBD (PRD §US-07).\nMenampilkan placeholder empty state.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColors.neutral600),
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
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: AppColors.primary600), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 11, color: AppColors.neutral600))]),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(total, style: const TextStyle(fontSize: 11, color: AppColors.neutral600))),
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
  const _Alert({required this.icon, required this.iconColor, required this.iconBg, required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.neutral600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
