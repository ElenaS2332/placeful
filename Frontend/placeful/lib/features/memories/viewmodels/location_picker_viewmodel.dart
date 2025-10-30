import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerViewModel extends ChangeNotifier {
  gmap.GoogleMapController? mapController;
  gmap.LatLng? _selectedPosition;
  gmap.LatLng? _currentPosition;
  String _locationName = "";

  gmap.LatLng? get selectedPosition => _selectedPosition;
  String get locationName => _locationName;
  gmap.LatLng? get currentPosition => _currentPosition;

  Future<void> onMapCreated(gmap.GoogleMapController controller) async {
    mapController = controller;
    await _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = gmap.LatLng(pos.latitude, pos.longitude);

      await mapController?.animateCamera(
        gmap.CameraUpdate.newCameraPosition(
          gmap.CameraPosition(target: _currentPosition!, zoom: 16),
        ),
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  void onMapTapped(gmap.LatLng position) {
    _selectedPosition = position;
    notifyListeners();
  }

  void setLocationName(String name) {
    _locationName = name;
    notifyListeners();
  }

  LocationDto? getSelectedLocation() {
    if (_selectedPosition == null) return null;
    return LocationDto(
      id: '',
      latitude: _selectedPosition!.latitude,
      longitude: _selectedPosition!.longitude,
      name: _locationName.isEmpty ? "Unnamed location" : _locationName,
    );
  }
}
