import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:placeful/common/domain/dtos/location_dto.dart';

class LocationPickerViewModel extends ChangeNotifier {
  gmap.GoogleMapController? mapController;
  gmap.LatLng? _selectedPosition;
  String _locationName = "";

  gmap.LatLng? get selectedPosition => _selectedPosition;
  String get locationName => _locationName;

  void onMapCreated(gmap.GoogleMapController controller) {
    mapController = controller;
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
      latitude: _selectedPosition!.latitude,
      longitude: _selectedPosition!.longitude,
      name: _locationName.isEmpty ? "Unnamed location" : _locationName,
    );
  }
}
