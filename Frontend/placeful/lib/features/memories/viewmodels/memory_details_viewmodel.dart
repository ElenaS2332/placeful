import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryDetailsViewModel extends ChangeNotifier {
  final Memory memory;
  final MemoryService memoryService = getIt<MemoryService>();

  MemoryDetailsViewModel(this.memory);

  bool _showMap = false;
  bool get showMap => _showMap;

  LatLng get memoryLocation =>
      LatLng(memory.location?.latitude ?? 0, memory.location?.longitude ?? 0);
  String get title => memory.title;
  String get description => memory.description;
  DateTime? get date => memory.date;
  String? get imageUrl => memory.imageUrl;
  String get locationName => memory.location?.name ?? 'Unknown location';

  void toggleMap() {
    _showMap = !_showMap;
    notifyListeners();
  }

  Future<void> updateMemory(Memory memory) async {
    await memoryService.updateMemory(memory);
  }

  Future<void> deleteMemory(String id) async {
    await memoryService.deleteMemory(id);
  }
}
