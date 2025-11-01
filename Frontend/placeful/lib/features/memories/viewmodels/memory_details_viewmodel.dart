import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryDetailsViewModel extends ChangeNotifier {
  final String memoryId;
  Memory? memory;
  final MemoryService memoryService = getIt<MemoryService>();

  MemoryDetailsViewModel(this.memoryId);

  bool _showMap = false;
  bool get showMap => _showMap;

  void toggleMap() {
    _showMap = !_showMap;
    notifyListeners();
  }

  Future<void> loadMemoryDetails() async {
    try {
      memory = await memoryService.getMemory(memoryId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading memory details: $e');
    }
  }

  Future<void> updateMemory(Memory memory) async {
    await memoryService.updateMemory(memory);
  }

  Future<void> deleteMemory(String id) async {
    await memoryService.deleteMemory(id);
  }

  Future<void> shareMemoryWith(String friendId) async {
    try {
      await memoryService.shareMemoryWith(memory!.id, friendId);
    } catch (e) {
      debugPrint('Error sharing memory: $e');
      rethrow;
    }
  }
}
