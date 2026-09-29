import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AppBar NavaGo: logo kiri + lonceng kanan (PRD: notifikasi via ikon lonceng).
class NavagoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final VoidCallback? onBellTap;
  const NavagoAppBar({super.key, this.title, this.showBack = false, this.onBellTap});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          if (showBack)
            IconButton(
              tooltip: 'Kembali',
              icon: const Icon(Icons.chevron_left, size: 26),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B8F76), Color(0xFF12A98A)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          ),
          const SizedBox(width: 8),
          if (title != null)
            Text(title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.neutral900))
          else
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(text: 'Nava', style: TextStyle(color: AppColors.navy900)),
                  TextSpan(text: 'Go', style: TextStyle(color: AppColors.primary600)),
                ],
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notifikasi',
          icon: const Icon(Icons.notifications_none_outlined, color: AppColors.neutral900),
          onPressed: onBellTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('3 notifikasi baru')),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
