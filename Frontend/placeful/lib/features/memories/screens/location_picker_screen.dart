import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed:
                _selectedPosition == null
                    ? null
                    : () {
                      final location = LocationDto(
                        latitude: _selectedPosition!.latitude,
                        longitude: _selectedPosition!.longitude,
                        name:
                            "Lat: ${_selectedPosition!.latitude}, Lng: ${_selectedPosition!.longitude}",
                      );
                      Navigator.pop(context, location);
                    },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.9981, 21.4254),
          zoom: 12,
        ),
        onMapCreated: (controller) => _mapController = controller,
        onTap: (LatLng position) {
          setState(() {
            _selectedPosition = position;
          });
        },
        markers:
            _selectedPosition == null
                ? {}
                : {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: _selectedPosition!,
                  ),
                },
      ),
    );
  }
}
