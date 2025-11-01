import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/shared_memory_dto.dart';
import 'package:placeful/common/services/memory_service.dart';

class SharedMemoryViewModel extends ChangeNotifier {
  final _memoryService = MemoryService();

  bool isLoading = false;
  String? error;
  List<SharedMemoryDto> sharedMemories = [];

  final Map<String, Color> _friendColors = {};

  Future<void> loadSharedMemories() async {
    isLoading = true;
    notifyListeners();

    try {
      sharedMemories = await _memoryService.listSharedMemoriesForCurrentUser();
      error = null;
    } catch (e) {
      error = "Failed to load shared memories.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Color getColorForFriend(String friendId) {
    if (_friendColors.containsKey(friendId)) {
      return _friendColors[friendId]!;
    }
    final colors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    final color = colors[_friendColors.length % colors.length];
    _friendColors[friendId] = color;
    return color;
  }
}
