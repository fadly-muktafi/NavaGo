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
                const CircleAvatar(
                    radius: 30, child: Icon(Icons.person_outline, size: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusBadge(
                          label: 'Aktif',
                          textColor: AppColors.successText,
                          bgColor: AppColors.successBg),
                      const SizedBox(height: 4),
                      Text(MockData.driverName,
                          style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: AppColors.star),
                          const SizedBox(width: 2),
                          Text('4.8 (128 ulasan)',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _ContactCell(
                        icon: Icons.phone_outlined,
                        label: 'No. HP',
                        value: MockData.driverPhone)),
                SizedBox(width: 12),
                Expanded(
                    child: _ContactCell(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: MockData.driverEmail)),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                        boxShadow: const [AppColors.cardShadow],
                      ),
                      child: const Column(
                        children: [
                          _ProfileRow(label: 'SIM', value: 'A Umum'),
                          _ProfileRow(
                              label: 'Berlaku hingga', value: '12 Jan 2027'),
                          _ProfileRow(
                              label: 'Kendaraan',
                              value: 'B 1234 KLM - Toyota Hiace'),
                          _ProfileRow(label: 'Total Trip', value: '156 Trip'),
                          _ProfileRow(
                              label: 'Rating', value: '4.8 (128 ulasan)'),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                        boxShadow: const [AppColors.cardShadow],
                      ),
                      child: const Column(
                        children: [
                          _ProfileRow(
                              label: 'SIM A Umum',
                              value: 'Berlaku s/d 12 Jan 2027'),
                          _ProfileRow(label: 'KTP', value: 'Terverifikasi'),
                          _ProfileRow(
                              label: 'SKCK', value: 'Berlaku s/d 01 Des 2025'),
                        ],
                      ),
                    );
                  }
                  return Column(
                    key: const ValueKey('riwayat'),
                    children: [
                      for (int i = 0; i < MockData.tripHistory.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        _TripHistory(
                          date: MockData.tripHistory[i].date,
                          route: MockData.tripHistory[i].route,
                          vehicle: MockData.tripHistory[i].vehicle,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Ubah Data'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                  'Form ubah data segera hadir. Perubahan rating, total trip, dan kendaraan ditugaskan mengikuti sistem.',
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center),
            ),
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
  const _ContactCell(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
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
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Tooltip(
                  message: value,
                  child: Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: textTheme.bodySmall)),
          const SizedBox(width: 8),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Tooltip(
                message: value,
                child: Text(value,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end),
              ),
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
  const _TripHistory(
      {required this.date, required this.route, required this.vehicle});
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(8)),
            child:
                const Icon(Icons.route, size: 20, color: AppColors.primary600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: route,
                  child: Text(route,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 2),
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
          // Guard gutter: teks penuh + ellipsis tak menempel badge.
          const SizedBox(width: 8),
          StatusBadge(
              label: 'Selesai',
              textColor: AppColors.successText,
              bgColor: AppColors.successBg),
        ],
      ),
    );
  }
}
