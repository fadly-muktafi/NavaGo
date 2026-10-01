import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
/// AppBar RentGo: logo + nama aplikasi di kiri, lonceng kanan
/// (PRD: notifikasi via ikon lonceng). Wordmark selalu tampil.
class NavagoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBellTap;
  const NavagoAppBar({super.key, this.showBack = false, this.onBellTap});

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
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/rentgo-logo.png',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary600, AppColors.primary500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text('R',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              children: [
                TextSpan(
                    text: 'Rent',
                    style: TextStyle(color: AppColors.navy900)),
                TextSpan(
                    text: 'Go', style: TextStyle(color: AppColors.primaryText)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notifikasi',
          icon: const Icon(Icons.notifications_none_outlined,
              color: AppColors.neutral900),
          onPressed: onBellTap ??
              () {
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
