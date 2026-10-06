import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/route_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Peta live perjalanan driver (tab Peta Monitoring): tile OSM +
/// rute jalan raya OSRM + marker asal/tujuan + marker posisi GPS.
///
/// - [livePosition]: stream posisi HP (null = belum ada izin mock).
/// - [routeService]/[locationService] injectable untuk test.
/// - Gagal/offline → garis lurus + catatan, peta tak pernah blank.
class TripMapView extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;
  final String originLabel;
  final String destinationLabel;
  final String infoText;

  /// Stream posisi live. WAJIB broadcast (mis. via asBroadcastStream SEKALI
  /// di sumber): didengar 2 StreamBuilder + di-listen ulang tiap remount
  /// tab — single-subscription pasti meledak "already been listened".
  final Stream<LatLng>? livePosition;
  final RouteService routeService;

  /// Dipanggil saat user mengetuk "Aktifkan GPS" (izin diminta atas
  /// gestur eksplisit — bukan saat app start).
  final VoidCallback? onEnableLocation;

  const TripMapView({
    super.key,
    required this.origin,
    required this.destination,
    required this.originLabel,
    required this.destinationLabel,
    required this.infoText,
    this.livePosition,
    this.onEnableLocation,
    this.routeService = const RouteService(),
  });

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  late final MapController _controller;
  late final Future<({List<LatLng> points, bool live})> _routeFuture;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
    _routeFuture =
        widget.routeService.fetchRoute(widget.origin, widget.destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Peta rute ${widget.originLabel} ke ${widget.destinationLabel}, '
          'status live. ${widget.infoText}.',
      child: Container(
        height: kMapHeight,
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              FutureBuilder<({List<LatLng> points, bool live})>(
                future: _routeFuture,
                builder: (context, snapshot) {
                  final points = snapshot.data?.points ??
                      RouteService.fallbackStraight(
                          widget.origin, widget.destination);
                  final liveRoute = snapshot.data?.live ?? false;
                  return StreamBuilder<LatLng>(
                    stream: widget.livePosition,
                    builder: (context, liveSnap) {
                      final livePos = liveSnap.data;
                      return FlutterMap(
                        mapController: _controller,
                        options: MapOptions(
                          initialCameraFit: CameraFit.coordinates(
                            coordinates: [widget.origin, widget.destination],
                            padding: const EdgeInsets.all(48),
                          ),
                          minZoom: 5,
                          maxZoom: 18,
                          backgroundColor: AppColors.neutral100,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.navago.rentgo',
                            errorTileCallback: (tile, error, stack) {},
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: points,
                                color: AppColors.info,
                                strokeWidth: 4,
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: widget.origin,
                                width: 60,
                                height: 56,
                                child: MapPin(
                                  icon: Icons.directions_bus,
                                  label: widget.originLabel,
                                  color: AppColors.primary600,
                                ),
                              ),
                              Marker(
                                point: widget.destination,
                                width: 60,
                                height: 56,
                                child: MapPin(
                                  icon: Icons.location_on,
                                  label: widget.destinationLabel,
                                  color: AppColors.danger,
                                ),
                              ),
                              if (livePos != null)
                                Marker(
                                  point: livePos,
                                  width: 34,
                                  height: 34,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary600,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                        Icons.navigation,
                                        color: Colors.white,
                                        size: 18),
                                  ),
                                ),
                            ],
                          ),
                          // Atribusi OSM (wajib kebijakan tile.openstreetmap.org).
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('© OpenStreetMap',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.neutral600)),
                            ),
                          ),
                          // Status rute: jalan raya vs fallback offline.
                          if (!liveRoute && snapshot.connectionState ==
                              ConnectionState.done)
                            Positioned(
                              left: 8,
                              top: 44,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warningBg,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('Rute langsung • offline',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: AppColors.warningText,
                                            fontWeight: FontWeight.w700)),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
              // Badge Live (overlay, sama seperti placeholder).
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
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              // Tombol izin eksplisit: hanya tampil bila stream belum ada.
              // (Izin lokasi diminta atas gestur user, bukan saat app start.)
              if (widget.livePosition == null &&
                  widget.onEnableLocation != null)
                Positioned(
                  right: 12,
                  bottom: 64,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: widget.onEnableLocation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          // primary700: teks putih 11px lolos 4.5:1 (5.28 ✓).
                          color: AppColors.primary700,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [AppColors.cardShadow],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.my_location,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text('Aktifkan GPS',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Pill info bawah (overlay).
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Center(
                  child: StreamBuilder<LatLng>(
                    stream: widget.livePosition,
                    builder: (context, liveSnap) {
                      final livePos = liveSnap.data;
                      final text = livePos == null
                          ? widget.infoText
                          : 'GPS ${livePos.latitude.toStringAsFixed(4)}, '
                              '${livePos.longitude.toStringAsFixed(4)}';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppColors.neutral200),
                            boxShadow: const [AppColors.cardShadow]),
                        child: Tooltip(
                          message: text,
                          child: Text(text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
