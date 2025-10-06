import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/features/memories/screens/memory_map_screen.dart';

class MemoryMapViewModel extends ChangeNotifier {
  final MemoryService _memoryService = getIt.get<MemoryService>();

  GoogleMapController? mapController;
  bool isLoading = false;
  Set<Marker> markers = {};

  Future<void> fetchLatestMemories(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final memories = await _memoryService.getMemories(page: 1, pageSize: 5);

      markers =
          memories
              .map((memory) {
                final lat = memory.location?.latitude;
                final lng = memory.location?.longitude;

                if (lat == null || lng == null) return null;

                return Marker(
                  markerId: MarkerId(memory.id),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: memory.title,
                    snippet: "Tap to view details",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemoryMapScreen(),
                          //  MemoryDetailsScreen(memory: memory),
                        ),
                      );
                    },
                  ),
                );
              })
              .whereType<Marker>()
              .toSet();
    } catch (e) {
      debugPrint("Error fetching memories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
