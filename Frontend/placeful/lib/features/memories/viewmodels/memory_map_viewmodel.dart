import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryMapViewModel extends ChangeNotifier {
  final MemoryService memoryService = getIt<MemoryService>();
  bool isLoading = false;
  Set<Marker> markers = {};

  Future<void> fetchLatestMemories() async {
    isLoading = true;
    notifyListeners();

    try {
      final allMemories = await memoryService.getMemories();

      final latestMemories =
          allMemories.where((m) => m.location != null).toList();

      final top5 = latestMemories.take(5);

      markers.clear();
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
    } catch (e) {
      debugPrint("Error fetching memories for map: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
