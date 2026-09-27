import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarangayMapView extends StatefulWidget {
  final String? selectedBarangay;
  final String selectedBloodType;
  final Function(String) onBarangaySelected;

  const BarangayMapView({
    super.key,
    required this.selectedBarangay,
    required this.selectedBloodType,
    required this.onBarangaySelected,
  });

  @override
  State<BarangayMapView> createState() => _BarangayMapViewState();
}

class _BarangayMapViewState extends State<BarangayMapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  final _supabase = Supabase.instance.client;

  Set<Marker> _donorMarkers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonorsFromSupabase();
  }

  @override
  void didUpdateWidget(covariant BarangayMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBarangay != widget.selectedBarangay ||
        oldWidget.selectedBloodType != widget.selectedBloodType) {
      _fetchDonorsFromSupabase();
    }
  }

  /// Query donors directly from Supabase DB
  Future<void> _fetchDonorsFromSupabase() async {
    setState(() => _isLoading = true);

    try {
      var query = _supabase.from('donors').select().eq('is_available', true);

      if (widget.selectedBloodType != 'ALL') {
        query = query.eq('blood_type', widget.selectedBloodType);
      }

      if (widget.selectedBarangay != null) {
        query = query.ilike('barangay', '%${widget.selectedBarangay}%');
      }

      final List<dynamic> response = await query;
      final Set<Marker> markers = {};

      for (var donor in response) {
        // Extract coordinates if stored or parse GeoJSON point
        final double? lat = donor['latitude'] as double?;
        final double? lng = donor['longitude'] as double?;

        if (lat != null && lng != null) {
          markers.add(
            Marker(
              markerId: MarkerId(donor['id']),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: '${donor['alias']} (${donor['blood_type']})',
                snippet: 'Barangay: ${donor['barangay']}',
              ),
            ),
          );
        }
      }

      setState(() {
        _donorMarkers = markers;
      });
    } catch (e) {
      debugPrint('Error fetching donors from Supabase: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(6.7583, 125.3572), // Digos City
            zoom: 13.0,
          ),
          markers: _donorMarkers,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _mapController.complete(controller),
        ),

        if (_isLoading)
          const Positioned(
            top: 20,
            left: 20,
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text('Loading live donors from Supabase...', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}