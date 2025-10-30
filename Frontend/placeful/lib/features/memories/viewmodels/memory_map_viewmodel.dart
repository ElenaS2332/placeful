import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_friendship_service.dart';

class MemoryMapViewModel extends ChangeNotifier {
  final MemoryService memoryService = getIt.get<MemoryService>();
  final UserFriendshipService friendshipService =
      getIt.get<UserFriendshipService>();

  bool isLoading = true;
  Set<Marker> markers = {};
  List<Memory> allMemories = List.empty(growable: true);
  int friendRequestsCount = 0;

  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  LatLng? get currentLocation => _currentLocation;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> initializeMap() async {
    await _determinePosition();
    await fetchLatestMemories();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        debugPrint("Location permission denied.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("Error determining position: $e");
    }
  }

  Future<void> fetchLatestMemories() async {
    try {
      allMemories = await memoryService.getMemories();

      final latestMemories =
          allMemories.where((m) => m.location != null).toList();

      final top5 = latestMemories.take(5);

      markers =
          top5.map((memory) {
            return Marker(
              markerId: MarkerId(memory.id),
              position: LatLng(
                memory.location!.latitude,
                memory.location!.longitude,
              ),
              infoWindow: InfoWindow(
                title: memory.title,
                snippet: memory.location!.name,
              ),
            );
          }).toSet();

      await fetchFriendshipRequests();
    } catch (e) {
      debugPrint("Error fetching memories for map: $e");
    }

    notifyListeners();
  }

  Future<void> fetchFriendshipRequests() async {
    try {
      friendRequestsCount = await friendshipService.getCountForFriendRequests();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching friend requests count: $e");
    }
  }

  Future<void> refreshData() async {
    await fetchLatestMemories();
  }

  Future<void> setCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final target = LatLng(position.latitude, position.longitude);
      _currentLocation = target;

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16),
        ),
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }
}
