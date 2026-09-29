import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common.dart';
import '../widgets/navago_app_bar.dart';
import 'armada_detail_screen.dart';

/// US-02 Daftar Armada — seluruh armada, read-only.
class ArmadaListScreen extends StatefulWidget {
  const ArmadaListScreen({super.key});
  @override
  State<ArmadaListScreen> createState() => _ArmadaListScreenState();
}

class _ArmadaListScreenState extends State<ArmadaListScreen> {
  int filter = 0;
  String query = '';
  static const filters = ['Semua', 'Tersedia', 'On Trip', 'Maintenance'];

  List<Vehicle> get shown {
    return MockData.vehicles.where((v) {
      final matchFilter = filter == 0 ||
          (filter == 1 && v.status == VehicleStatus.tersedia) ||
          (filter == 2 && v.status == VehicleStatus.onTrip) ||
          (filter == 3 && v.status == VehicleStatus.maintenance);
      final q = query.toLowerCase();
      final matchQuery = q.isEmpty ||
          v.plat.toLowerCase().contains(q) ||
          v.tipe.toLowerCase().contains(q) ||
          v.lokasi.toLowerCase().contains(q);
      return matchFilter && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = shown;
    return Scaffold(
      appBar: const NavagoAppBar(title: 'Daftar Armada'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Daftar Armada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                Text('${MockData.vehicles.length} Armada', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            NavagoSearch(hint: 'Cari plat nomor, tipe, atau lokasi...', onChanged: (v) => setState(() => query = v)),
            const SizedBox(height: 10),
            FilterChips(labels: filters, selected: filter, onSelected: (i) => setState(() => filter = i)),
            const SizedBox(height: 10),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Belum ada armada yang cocok.'))
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final v = list[i];
                        return VehicleListItem(
                          plat: v.plat, tipe: v.tipe, kapasitas: v.kapasitas, lokasi: v.lokasi,
                          statusLabel: v.status.label, statusFg: v.status.textColor, statusBg: v.status.bgColor,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ArmadaDetailScreen(vehicle: v)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
