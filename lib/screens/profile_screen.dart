import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';

/// US-05 Profile view-only (form Ubah Data ditunda).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int tab = 0;
  static const tabs = ['Informasi', 'Dokumen', 'Riwayat Trip'];
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() => tab = i);
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
          children: [
            // Header
            Row(
              children: [
                const CircleAvatar(radius: 30, child: Icon(Icons.person_outline, size: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusBadge(label: 'Aktif', textColor: AppColors.successText, bgColor: AppColors.successBg),
                      const SizedBox(height: 4),
                      Text(MockData.driverName, style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.star),
                          const SizedBox(width: 2),
                          Text('4.8 (128 ulasan)', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _ContactCell(icon: Icons.phone_outlined, label: 'No. HP', value: MockData.driverPhone)),
                SizedBox(width: 12),
                Expanded(child: _ContactCell(icon: Icons.email_outlined, label: 'Email', value: MockData.driverEmail)),
              ],
            ),
            const SizedBox(height: 12),
            FilterChips(labels: tabs, selected: tab, onSelected: _selectTab),
            const SizedBox(height: 12),
            // Ganti tab di-crossfade (bukan jump); reduce-motion = instan.
            AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              switchInCurve: kEaseOut,
              switchOutCurve: kEaseOut,
              child: Builder(
                key: ValueKey(tab),
                builder: (context) {
                  if (tab == 0) {
                    return Container(
                      key: const ValueKey('info'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                        boxShadow: const [AppColors.cardShadow],
                      ),
                      child: const Column(
                        children: [
                          _ProfileRow(label: 'SIM', value: 'A Umum'),
                          _ProfileRow(label: 'Berlaku hingga', value: '12 Jan 2027'),
                          _ProfileRow(label: 'Kendaraan Ditugaskan', value: 'B 1234 KLM (Toyota Hiace)'),
                          _ProfileRow(label: 'Total Trip', value: '156 Trip'),
                          _ProfileRow(label: 'Rating', value: '4.8 (128 ulasan)'),
                        ],
                      ),
                    );
                  }
                  if (tab == 1) {
                    return Container(
                      key: const ValueKey('dokumen'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                        boxShadow: const [AppColors.cardShadow],
                      ),
                      child: const Column(
                        children: [
                          _ProfileRow(label: 'SIM A Umum', value: 'Berlaku s/d 12 Jan 2027'),
                          _ProfileRow(label: 'KTP', value: 'Terverifikasi'),
                          _ProfileRow(label: 'SKCK', value: 'Berlaku s/d 01 Des 2025'),
                        ],
                      ),
                    );
                  }
                  return Column(
                    key: const ValueKey('riwayat'),
                    children: const [
                      _TripHistory(date: '14 Mei 2024', route: 'Jakarta → Bandung', vehicle: 'B 1234 KLM • Hiace'),
                      SizedBox(height: 8),
                      _TripHistory(date: '12 Mei 2024', route: 'Jakarta → Bekasi', vehicle: 'B 9012 QRS • Dutro'),
                      SizedBox(height: 8),
                      _TripHistory(date: '10 Mei 2024', route: 'Depok → Tangerang', vehicle: 'B 6789 WXY • Avanza'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Ubah Data'),
              ),
            ),
            const SizedBox(height: 6),
            Text('Form ubah data segera hadir. Perubahan rating, total trip, dan kendaraan ditugaskan mengikuti sistem.',
              style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ContactCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactCell({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                Tooltip(
                  message: value,
                  child: Text(value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textTheme.bodySmall)),
          const SizedBox(width: 8),
          Flexible(
            child: Tooltip(
              message: value,
              child: Text(value,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripHistory extends StatelessWidget {
  final String date;
  final String route;
  final String vehicle;
  const _TripHistory({required this.date, required this.route, required this.vehicle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.primary100, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.route, color: AppColors.primary600),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: route,
                  child: Text(route,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Tooltip(
                  message: '$date • $vehicle',
                  child: Text('$date • $vehicle',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          StatusBadge(label: 'Selesai', textColor: AppColors.successText, bgColor: AppColors.successBg),
        ],
      ),
    );
  }
}
