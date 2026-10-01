import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Mock data UI-only — tiru isi desain-ui.jpeg.
/// Nanti diganti kontrak API (PRD §4.4 TBD).

enum VehicleStatus { tersedia, onTrip, maintenance }

extension VehicleStatusX on VehicleStatus {
  String get label {
    switch (this) {
      case VehicleStatus.tersedia:
        return 'Tersedia';
      case VehicleStatus.onTrip:
        return 'On Trip';
      case VehicleStatus.maintenance:
        return 'Maintenance';
    }
  }

  Color get textColor {
    switch (this) {
      case VehicleStatus.tersedia:
        return AppColors.primaryText;
      case VehicleStatus.onTrip:
        return AppColors.infoText;
      case VehicleStatus.maintenance:
        return AppColors.dangerText;
    }
  }

  Color get bgColor {
    switch (this) {
      case VehicleStatus.tersedia:
        return AppColors.primary100;
      case VehicleStatus.onTrip:
        return AppColors.infoBg;
      case VehicleStatus.maintenance:
        return AppColors.dangerBg;
    }
  }
}

class Vehicle {
  final String plat;
  final String tipe;
  final String kapasitas;
  final String lokasi;
  final VehicleStatus status;
  const Vehicle({
    required this.plat,
    required this.tipe,
    required this.kapasitas,
    required this.lokasi,
    required this.status,
  });
}

class MaintenanceItemData {
  final String judul;
  final String subjudul; // plat • tipe
  final String tanggal;
  final String sisa; // "3 hari lagi"
  final MaintenanceKind kind;
  const MaintenanceItemData({
    required this.judul,
    required this.subjudul,
    required this.tanggal,
    required this.sisa,
    required this.kind,
  });

  /// Sisa hari ter-parse dari label ("3 hari lagi" -> 3).
  int? get daysLeft => int.tryParse(sisa.split(' ').first);
}

enum MaintenanceKind { service, dokumen, lainnya }

/// Ringkasan satu penugasan trip milik driver (sumber tunggal untuk
/// layar Penugasan dan section "Tugas berikutnya" di Beranda).
class TripSummary {
  final String id;
  final String rute;
  final String tanggal;
  final String waktu;
  final String penumpang;
  final String tipe;
  final String plat;
  final String kendaraan;
  const TripSummary({
    required this.id,
    required this.rute,
    required this.tanggal,
    required this.waktu,
    required this.penumpang,
    required this.tipe,
    required this.plat,
    required this.kendaraan,
  });
}

class MockData {
  static const driverName = 'Budi Santoso';
  static const driverPhone = '0812 3456 7890';
  static const driverEmail = 'budi.santoso@mail.com';
  static const greetingDate = 'Selasa, 14 Mei 2024';

  static const vehicles = <Vehicle>[
    Vehicle(plat: 'B 1234 KLM', tipe: 'Toyota Hiace', kapasitas: '12 Kursi', lokasi: 'Jakarta Pusat', status: VehicleStatus.tersedia),
    Vehicle(plat: 'B 5678 NOP', tipe: 'Isuzu Elf', kapasitas: '9 Kursi', lokasi: 'Surabaya', status: VehicleStatus.onTrip),
    Vehicle(plat: 'B 9012 QRS', tipe: 'Hino Dutro', kapasitas: '8 Ton', lokasi: 'Bekasi', status: VehicleStatus.tersedia),
    Vehicle(plat: 'B 3456 TUV', tipe: 'Mitsubishi Fuso', kapasitas: '8 Ton', lokasi: 'Depok', status: VehicleStatus.maintenance),
    Vehicle(plat: 'B 6789 WXY', tipe: 'Toyota Avanza', kapasitas: '7 Kursi', lokasi: 'Tangerang', status: VehicleStatus.tersedia),
  ];

  static const maintenances = <MaintenanceItemData>[
    MaintenanceItemData(judul: 'Ganti Oli', subjudul: 'B 1234 KLM • Toyota Hiace', tanggal: '15 Mei 2024', sisa: '3 hari lagi', kind: MaintenanceKind.service),
    MaintenanceItemData(judul: 'Service Berkala', subjudul: 'B 6789 WXY • Avanza', tanggal: '20 Mei 2024', sisa: '8 hari lagi', kind: MaintenanceKind.service),
    MaintenanceItemData(judul: 'KIR (Uji Kendaraan)', subjudul: 'B 5678 NOP • Isuzu Elf', tanggal: '28 Mei 2024', sisa: '16 hari lagi', kind: MaintenanceKind.dokumen),
    MaintenanceItemData(judul: 'Perpanjangan STNK', subjudul: 'B 9012 QRS • Hino Dutro', tanggal: '10 Juni 2024', sisa: '27 hari lagi', kind: MaintenanceKind.dokumen),
    MaintenanceItemData(judul: 'Perpanjangan Asuransi', subjudul: 'B 3456 TUV • Mitsubishi Fuso', tanggal: '15 Juni 2024', sisa: '32 hari lagi', kind: MaintenanceKind.lainnya),
  ];

  // Dashboard KPI sesuai mockup
  static const kpiTotalArmada = '48';
  static const kpiTersedia = '28';
  static const kpiOnTrip = '15';
  static const kpiMaintenance = '5';
  static const kpiDriverAktif = '42';
  static const kpiDokJatuhTempo = '7';

  /// Maksimal 3 tugas teratas terurut tanggal terdekat. Satu-satunya
  /// sumber data trip untuk Beranda dan Penugasan — tugas baru cukup
  /// ditambahkan di sini (nanti: 3 teratas dari API terurut tanggal).
  static const tugasTerdekat = <TripSummary>[
    TripSummary(
      id: 'TRP-20240514-001',
      rute: 'Jakarta → Bandung',
      tanggal: '15 Mei 2024',
      waktu: '08:00 – 16:00 (1 Hari)',
      penumpang: '10 Orang',
      tipe: 'Reguler',
      plat: 'B 1234 KLM',
      kendaraan: 'Toyota Hiace • 12 kursi',
    ),
    TripSummary(
      id: 'TRP-20240516-002',
      rute: 'Jakarta → Bogor',
      tanggal: '16 Mei 2024',
      waktu: '09:00 – 14:00 (1 Hari)',
      penumpang: '7 Orang',
      tipe: 'Reguler',
      plat: 'B 6789 WXY',
      kendaraan: 'Toyota Avanza • 7 kursi',
    ),
    TripSummary(
      id: 'TRP-20240518-003',
      rute: 'Bandung → Jakarta',
      tanggal: '18 Mei 2024',
      waktu: '08:00 – 16:00 (1 Hari)',
      penumpang: '10 Orang',
      tipe: 'Carter',
      plat: 'B 1234 KLM',
      kendaraan: 'Toyota Hiace • 12 kursi',
    ),
  ];
}
