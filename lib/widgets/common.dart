import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge status pill — teks selalu ada (a11y: tidak hanya warna).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;
  const StatusBadge({super.key, required this.label, required this.textColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600, color: textColor,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: style),
    );
  }
}

/// Badge sisa hari maintenance: merah <=3, kuning <=8, biru/hijau lainnya.
class DueBadge extends StatelessWidget {
  final String label;
  const DueBadge({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    Color fg = AppColors.info;
    Color bg = AppColors.infoBg;
    if (label.startsWith('3')) { fg = AppColors.danger; bg = AppColors.dangerBg; }
    else if (label.startsWith('8')) { fg = AppColors.warning; bg = AppColors.warningBg; }
    return StatusBadge(label: label, textColor: fg, bgColor: bg);
  }
}

/// Search field sesuai DESIGN §5.3.
class NavagoSearch extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const NavagoSearch({super.key, required this.hint, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
      ),
    );
  }
}

/// Chip filter pill — aktif hijau solid, non-aktif abu.
class FilterChips extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  const FilterChips({super.key, required this.labels, required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == selected;
          return ChoiceChip(
            label: Text(labels[i], softWrap: false, maxLines: 1, overflow: TextOverflow.visible),
            selected: active,
            onSelected: (_) => onSelected(i),
            labelStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.neutral600,
            ),
            backgroundColor: AppColors.neutral100,
            selectedColor: AppColors.primary600,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }
}

/// Kartu KPI dashboard (grid 2 kolom).
class KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final Color? valueColor;
  const KpiCard({super.key, required this.icon, required this.iconColor, required this.iconBg, required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(value,
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 22,
                    color: valueColor ?? AppColors.neutral900,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item list kendaraan (foto placeholder + plat + badge + tipe + lokasi).
class VehicleListItem extends StatelessWidget {
  final String plat;
  final String tipe;
  final String kapasitas;
  final String lokasi;
  final String statusLabel;
  final Color statusFg;
  final Color statusBg;
  final VoidCallback? onTap;
  const VehicleListItem({
    super.key, required this.plat, required this.tipe, required this.kapasitas,
    required this.lokasi, required this.statusLabel, required this.statusFg,
    required this.statusBg, this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200),
          boxShadow: const [AppColors.cardShadow],
        ),
        child: Row(
          children: [
            Container(
              width: 64, height: 48,
              decoration: BoxDecoration(color: AppColors.neutral100, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.directions_bus, color: AppColors.neutral400),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(plat, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
                      StatusBadge(label: statusLabel, textColor: statusFg, bgColor: statusBg),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('$tipe • $kapasitas', style: textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.neutral400),
                      const SizedBox(width: 2),
                      Expanded(child: Text(lokasi, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}

/// Item timeline maintenance.
class MaintenanceListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String judul;
  final String subjudul;
  final String tanggal;
  final String sisa;
  const MaintenanceListItem({
    super.key, required this.icon, required this.iconColor, required this.iconBg,
    required this.judul, required this.subjudul, required this.tanggal, required this.sisa,
  });
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(subjudul, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tanggal, style: textTheme.labelSmall),
              const SizedBox(height: 4),
              DueBadge(label: sisa),
            ],
          ),
        ],
      ),
    );
  }
}

/// Header section dengan link "Lihat Semua".
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;
  const SectionHeader({super.key, required this.title, this.onSeeAll, this.seeAllLabel});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(seeAllLabel ?? 'Lihat semua $title',
              style: const TextStyle(color: AppColors.primary500, fontSize: 12)),
          ),
      ],
    );
  }
}

/// Stepper 2 langkah Penugasan (PRD: Detail Trip → Konfirmasi).
class TripStepper extends StatelessWidget {
  final int current; // 0 atau 1
  const TripStepper({super.key, this.current = 0});
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);
    const labels = ['Detail Trip', 'Konfirmasi'];
    return Row(
      children: List.generate(2, (i) {
        final active = i <= current;
        final color = active ? AppColors.primary600 : AppColors.neutral200;
        final textColor = active ? AppColors.primary600 : AppColors.neutral400;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(color: active ? AppColors.primary600 : AppColors.neutral200, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              Text(labels[i], style: labelStyle?.copyWith(color: textColor)),
              if (i == 0) Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: color)),
            ],
          ),
        );
      }),
    );
  }
}

/// Placeholder peta (keputusan: placeholder dulu, tanpa map provider).
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Peta rute Jakarta ke Bandung, status live. Kendaraan B 1234 KLM 70 kilometer per jam menuju Bandung.',
      child: Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Stack(
        children: [
          CustomPaint(painter: _RoutePainter(), size: Size.infinite),
          const Positioned(
            left: 12, top: 40,
            child: _MapPin(icon: Icons.directions_bus, label: 'Jakarta', color: AppColors.primary600),
          ),
          const Positioned(
            right: 16, bottom: 36,
            child: _MapPin(icon: Icons.location_on, label: 'Bandung', color: AppColors.danger),
          ),
          Positioned(
            right: 12, top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.neutral200)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: AppColors.primary600),
                  SizedBox(width: 4),
                  Text('Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary600)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 12,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.neutral200), boxShadow: const [AppColors.cardShadow]),
                child: const Text('B 1234 KLM • 70 km/jam • Menuju Bandung',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MapPin({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.info
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.35)
      ..cubicTo(size.width * 0.35, size.height * 0.2, size.width * 0.45, size.height * 0.7, size.width * 0.8, size.height * 0.6);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
