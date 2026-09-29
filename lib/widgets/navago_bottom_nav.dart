import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bottom nav 5 tab sesuai PRD §2.2:
/// Beranda · Armada · Penugasan · Monitoring · Profile.
class NavagoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const NavagoBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'Beranda'),
      (Icons.directions_bus_outlined, Icons.directions_bus, 'Armada'),
      (Icons.assignment_outlined, Icons.assignment, 'Penugasan'),
      (Icons.map_outlined, Icons.map, 'Monitoring'),
      (Icons.person_outline, Icons.person, 'Profile'),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [AppColors.bottomNavShadow],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == currentIndex;
              final color = active ? AppColors.primary600 : AppColors.neutral400;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(active ? items[i].$2 : items[i].$1, color: color, size: 24),
                        const SizedBox(height: 2),
                        Text(items[i].$3,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
