import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Nama family font Plus Jakarta Sans yang di-bundle di `fonts/`
/// (dideklarasikan di pubspec.yaml). Dibundle agar metrik teks stabil
/// sejak frame pertama — tidak menunggu unduhan runtime.
const String kFontFamily = 'PlusJakartaSans';

TextStyle _style({
  required double size,
  required FontWeight weight,
  required Color color,
}) {
  return TextStyle(
    fontFamily: kFontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}

/// Theme RentGo — Plus Jakarta Sans (bundle lokal), Material 3.
/// Mengikuti DESIGN.md §4.2–4.5.
ThemeData buildNavagoTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary600,
      primary: AppColors.primary600,
      surface: AppColors.white,
    ),
  );

  final textTheme = base.textTheme.copyWith(
    displayLarge: _style(size: 28, weight: FontWeight.bold, color: AppColors.neutral900),
    // Angka KPI/ringkasan — tabular diterapkan di titik pakai.
    displayMedium: _style(size: 22, weight: FontWeight.w800, color: AppColors.neutral900),
    titleLarge: _style(size: 18, weight: FontWeight.bold, color: AppColors.neutral900),
    titleMedium: _style(size: 16, weight: FontWeight.w600, color: AppColors.neutral900),
    bodyLarge: _style(size: 16, weight: FontWeight.normal, color: AppColors.neutral900),
    bodyMedium: _style(size: 14, weight: FontWeight.normal, color: AppColors.neutral900),
    bodySmall: _style(size: 12, weight: FontWeight.normal, color: AppColors.neutral600),
    labelSmall: _style(size: 11, weight: FontWeight.w500, color: AppColors.neutral600),
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.neutral900),
      titleTextStyle: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.neutral900,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: const StadiumBorder(),
      showCheckmark: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // primary700 (5.28:1) agar teks putih 14px lolos 4.5:1
        // (primary600 hanya 4.03:1) — sama seperti pill chip terpilih.
        backgroundColor: AppColors.primary700,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: kFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary600,
        side: const BorderSide(color: AppColors.primary600, width: 1.5),
        minimumSize: const Size(0, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: kFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.neutral200),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral100,
      hintStyle: _style(size: 13, weight: FontWeight.normal, color: AppColors.neutral400),
      prefixIconColor: AppColors.neutral400,
      suffixIconColor: AppColors.neutral600,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary600, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
  );
}

/// Kurva ease-out kuat untuk entrance/interaksi (ala Emil: bawaan terlalu
/// lemah). Dipakai semua animasi entrance agar satu bahasa gerak.
const kEaseOut = Cubic(0.23, 1, 0.32, 1);
