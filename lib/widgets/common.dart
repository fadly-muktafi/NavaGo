import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Badge status pill — teks selalu ada (a11y: tidak hanya warna).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;
  const StatusBadge(
      {super.key,
      required this.label,
      required this.textColor,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        );
    return Container(
      padding: kPillPadding,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: textColor.withValues(alpha: 0.25))),
      child: Text(label, style: style),
    );
  }
}

/// Pasangan warna urgensi jatuh tempo dari sisa hari: kritis <=3,
/// segera <=8, normal selebihnya. Satu-satunya definisi aturan —
/// dipakai DueBadge dan layar Detail Armada.
({Color fg, Color bg}) dueColorsFor(int? daysLeft) {
  if (daysLeft != null && daysLeft <= 3) {
    return (fg: AppColors.dangerText, bg: AppColors.dangerBg);
  }
  if (daysLeft != null && daysLeft <= 8) {
    return (fg: AppColors.warningText, bg: AppColors.warningBg);
  }
  return (fg: AppColors.infoText, bg: AppColors.infoBg);
}

/// Badge sisa hari maintenance: merah <=3 hari, amber gelap <=8 hari,
/// biru/info selebihnya. Angka di-parse agar '30 hari lagi' tidak ikut merah.
class DueBadge extends StatelessWidget {
  final String label;
  const DueBadge({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    final c = dueColorsFor(int.tryParse(label.split(' ').first));
    return StatusBadge(label: label, textColor: c.fg, bgColor: c.bg);
  }
}

/// Search field sesuai DESIGN §5.3 — dengan cincin fokus dan tombol hapus
/// yang muncul hanya saat ada teks.
class NavagoSearch extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const NavagoSearch(
      {super.key, required this.hint, this.controller, this.onChanged});

  @override
  State<NavagoSearch> createState() => _NavagoSearchState();
}

class _NavagoSearchState extends State<NavagoSearch> {
  late final TextEditingController _controller;
  bool _owned = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _owned = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(NavagoSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onText);
      if (_owned) _controller.dispose();
      _owned = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_onText);
    }
  }

  void _onText() {
    // Rebuild hanya saat kosong<->terisi berubah — bukan tiap karakter.
    // (Karakter per karakter sudah me-rebuild via onChanged parent;
    // listener ini hanya memastikan ikon clear tepat waktu.)
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onText);
    if (_owned) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 150),
          switchInCurve: kEaseOut,
          switchOutCurve: kEaseOut,
          child: _hasText
              ? IconButton(
                  key: const ValueKey('clear'),
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}

/// Chip filter pill — full-width: deretan chip selalu memenuhi lebar layar
/// dengan gap antar-chip tetap 8px. Sisa ruang disalurkan merata sebagai
/// padding horizontal yang sama besar di setiap chip, sehingga lebar chip
/// mengikuti teks (tanpa potong, tanpa ubah ukuran font). Bila teks terlalu
/// panjang untuk satu baris, fallback ke baris scroll horizontal.
class FilterChips extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  const FilterChips(
      {super.key,
      required this.labels,
      required this.selected,
      required this.onSelected});

  static const _gap = 8.0;
  static const _basePadH = 16.0; // 12 padding + 4 labelPadding per sisi
  static const _labelStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  double _textWidth(BuildContext context, String text) {
    final style = DefaultTextStyle.of(context).style.merge(_labelStyle);
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    // Bulatkan ke atas (+0.5 slop antialiasing) agar hasil ukur tidak pernah
    // lebih kecil dari hasil render — mencegah RenderFlex overflowed.
    return (tp.width + 0.5).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = labels.length;
        final textWidths = labels.map((l) => _textWidth(context, l)).toList();
        final totalText = textWidths.fold(0.0, (a, b) => a + b);
        final totalGaps = _gap * (n - 1);
        final baseTotal = totalText + _basePadH * 2 * n + totalGaps;

        Widget row(double padH) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < n; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  _chip(context, i, padH),
                ],
              ],
            );

        // Ruang tidak cukup: scroll horizontal dengan padding dasar.
        // SingleChildScrollView (bukan ListView fixed-height) agar tinggi
        // mengikuti chip saat font-scale membesar — tanpa overflow.
        // minHeight yang sama: garansi ketuk berlaku di kedua jalur.
        if (baseTotal > constraints.maxWidth) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              child: row(_basePadH),
            ),
          );
        }

        // Sisa ruang dibagi rata sebagai padding horizontal tiap chip.
        // minHeight 44 (bukan fixed) agar baris ikut tumbuh saat font-scale
        // membesar; area ketuk chip selalu >=44.
        final padH = _basePadH + (constraints.maxWidth - baseTotal) / n / 2;
        return Container(
          constraints: const BoxConstraints(minHeight: 44),
          child: row(padH),
        );
      },
    );
  }

  Widget _chip(BuildContext context, int i, double padH) {
    final active = i == selected;
    final base = DefaultTextStyle.of(context).style;
    // Transisi warna 150ms (bukan gerak posisi); reduce-motion = instan.
    final colorDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 150);
    return Semantics(
      selected: active,
      button: true,
      label: labels[i],
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onSelected(i),
          // Satu AnimatedContainer: warna teranimasi saat tap (frekuens-
          // tinggi); padding hanya berubah saat rotasi (jarang, portrait-
          // only). Pill memenuhi lebar: sisa ruang = padding di dalam pill.
          child: AnimatedContainer(
            duration: colorDuration,
            curve: kEaseOut,
            padding: EdgeInsets.symmetric(horizontal: padH, vertical: 14),
            decoration: BoxDecoration(
              // Pill terpilih memakai primary700 agar teks putih lolos 4.5:1
              // (terukur 5.28:1; primary600 hanya 4.03:1).
              color: active ? AppColors.primary700 : AppColors.neutral100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              labels[i],
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: base.merge(_labelStyle).copyWith(
                    color: active ? Colors.white : AppColors.neutral600,
                  ),
            ),
          ),
        ),
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
  const KpiCard(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.iconBg,
      required this.label,
      required this.value,
      this.valueColor});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: label,
                  child: Text(label,
                      style: textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 2),
                Text(value,
                    style: textTheme.displayMedium?.copyWith(
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
    super.key,
    required this.plat,
    required this.tipe,
    required this.kapasitas,
    required this.lokasi,
    required this.statusLabel,
    required this.statusFg,
    required this.statusBg,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
            boxShadow: const [AppColors.cardShadow],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'vehicle-$plat',
                child: Container(
                  width: 64,
                  height: 48,
                  decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.directions_bus_outlined,
                      color: AppColors.neutral400),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Tooltip(
                          message: plat,
                          child: Text(plat,
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        )),
                        StatusBadge(
                            label: statusLabel,
                            textColor: statusFg,
                            bgColor: statusBg),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('$tipe • $kapasitas', style: textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.neutral400),
                        const SizedBox(width: 2),
                        Expanded(
                            child: Text(lokasi,
                                style: textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              // Guard gutter: teks penuh + ellipsis tak menempel chevron.
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.neutral400),
            ],
          ),
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
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.judul,
    required this.subjudul,
    required this.tanggal,
    required this.sisa,
  });
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subjudul,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Guard gutter sebelum kolom tanggal/badge.
          const SizedBox(width: 8),
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
  const SectionHeader(
      {super.key, required this.title, this.onSeeAll, this.seeAllLabel});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        if (onSeeAll != null)
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(64, 44),
            ),
            onPressed: onSeeAll,
            child: Text(seeAllLabel ?? 'Lihat semua $title',
                style: const TextStyle(
                    color: AppColors.primaryText, fontSize: 12)),
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
    final labelStyle = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(fontWeight: FontWeight.w600);
    const labels = ['Detail Trip', 'Konfirmasi'];
    return Row(
      children: List.generate(2, (i) {
        final active = i <= current;
        final color = active ? AppColors.primary600 : AppColors.neutral200;
        // Kontras terukur: label 11px butuh 4.5:1 — primaryText 6.45 ✓,
        // neutral500 4.62 ✓ (primary600 4.03 / neutral400 2.55 ✗).
        final textColor = active ? AppColors.primaryText : AppColors.neutral500;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    // primary700: angka putih 12px butuh 4.5:1 (5.28 ✓).
                    color: active ? AppColors.primary700 : AppColors.neutral200,
                    shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text(labels[i], style: labelStyle?.copyWith(color: textColor)),
              if (i == 0)
                Expanded(
                    child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: color)),
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
      label:
          'Peta rute Jakarta ke Bandung, status live. Kendaraan B 1234 KLM 70 kilometer per jam menuju Bandung.',
      child: Container(
        height: kMapHeight,
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Stack(
          children: [
            CustomPaint(painter: _RoutePainter(), size: Size.infinite),
            const Positioned(
              left: 12,
              top: 40,
              child: _MapPin(
                  icon: Icons.directions_bus,
                  label: 'Jakarta',
                  color: AppColors.primary600),
            ),
            const Positioned(
              right: 16,
              bottom: 36,
              child: _MapPin(
                  icon: Icons.location_on,
                  label: 'Bandung',
                  color: AppColors.danger),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: kPillPadding,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.neutral200)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle,
                        size: 8, color: AppColors.primaryText),
                    const SizedBox(width: 4),
                    Text('Live',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText)),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutral200),
                      boxShadow: const [AppColors.cardShadow]),
                  child: Text('B 1234 KLM • 70 km/jam • Menuju Bandung',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
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
      ..cubicTo(size.width * 0.35, size.height * 0.2, size.width * 0.45,
          size.height * 0.7, size.width * 0.8, size.height * 0.6);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Kartu ringkas tugas terdekat (section Beranda). Seluruh kartu satu area
/// ketuk dengan ripple ter-clip; teks single-line + tooltip anti-overflow.
class TugasBerikutnyaCard extends StatelessWidget {
  final TripSummary trip;
  final VoidCallback? onTap;
  const TugasBerikutnyaCard({super.key, required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Jujur: umumkan tombol hanya bila benar bisa diketuk.
    // (InkWell onTap:null otomatis tanpa ripple — render statis.)
    return Semantics(
      button: onTap != null,
      label: 'Tugas berikutnya: ${trip.rute}, ${trip.tanggal}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral200),
              boxShadow: const [AppColors.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: trip.rute,
                        child: Text(trip.rute,
                            style: textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(
                        label: trip.tipe,
                        textColor: AppColors.primaryText,
                        bgColor: AppColors.primary100),
                  ],
                ),
                const SizedBox(height: 4),
                Tooltip(
                  message: '${trip.tanggal} • ${trip.waktu}',
                  child: Text('${trip.tanggal} • ${trip.waktu}',
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.directions_bus,
                          color: AppColors.primary600, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message: trip.plat,
                            child: Text(trip.plat,
                                style: textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(height: 2),
                          Tooltip(
                            message: trip.kendaraan,
                            child: Text(trip.kendaraan,
                                style: textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    // Guard gutter: teks penuh + ellipsis tak menempel chevron.
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right,
                        color: AppColors.neutral400),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
