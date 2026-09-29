import 'package:flutter/material.dart';

/// Design tokens dari DESIGN.md §4 (estimasi visual, TODO: cocokkan Figma).
abstract class AppColors {
  // Brand / Primary
  static const primary600 = Color(0xFF0B8F76);
  static const primary700 = Color(0xFF097A64);
  static const primary500 = Color(0xFF12A98A);
  static const primary100 = Color(0xFFDDF4EC);
  static const primary50 = Color(0xFFEEFAF6);
  static const navy900 = Color(0xFF12324A);

  // Neutral
  static const neutral900 = Color(0xFF1B2430);
  static const neutral600 = Color(0xFF5C6675);
  static const neutral400 = Color(0xFF9AA3AF);
  static const neutral200 = Color(0xFFE5E9EE);
  static const neutral100 = Color(0xFFF3F5F8);
  static const white = Color(0xFFFFFFFF);

  // Semantic text
  static const success = Color(0xFF0B8F76);
  static const successBg = Color(0xFFDDF4EC);
  static const info = Color(0xFF2F80ED);
  static const infoBg = Color(0xFFE3EEFD);
  static const danger = Color(0xFFE5484D);
  static const dangerBg = Color(0xFFFDE7E8);
  static const warning = Color(0xFFF2A11B);
  static const warningBg = Color(0xFFFFF1D6);
  static const muted = Color(0xFF6B7280);
  static const mutedBg = Color(0xFFEDEFF2);

  static const star = Color(0xFFF5A623);

  // Shape & shadow
  static const cardShadow = BoxShadow(
    color: Color(0x0F12324A), // rgba(18,50,74,0.06)
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const bottomNavShadow = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 12,
    offset: Offset(0, -2),
  );
}
