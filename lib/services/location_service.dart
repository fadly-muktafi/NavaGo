import 'package:geolocator/geolocator.dart';

/// Status izin/posisi lokasi HP driver (sumber: GPS ponsel, sesuai PRD).
enum LocationState { unknown, granted, denied, deniedForever, unavailable }

/// Wrapper Geolocator agar UI tipis & bisa di-test.
/// Izin diminta saat tab Peta pertama dibuka (bukan saat app start);
/// ditolak → pemanggil pakai posisi mock.
class LocationService {
  const LocationService();

  /// Minta izin lokasi. Kembalikan status akhir.
  Future<LocationState> requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationState.unavailable;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse =>
        LocationState.granted,
      LocationPermission.deniedForever => LocationState.deniedForever,
      _ => LocationState.denied,
    };
  }

  /// Stream posisi selama tab Peta terbuka. Pemanggil wajib cancel.
  Stream<Position> positionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // hemat baterai: update tiap 20 m
      ),
    );
  }

  /// Buka pengaturan app (untuk deniedForever).
  Future<void> openSettings() => Geolocator.openAppSettings();
}
