import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class ListMemoriesViewModel extends ChangeNotifier {
  final MemoryService _memoryService = getIt.get<MemoryService>();
  final bool _isLoading = false;
  final List<Memory> _memories = List<Memory>.empty(growable: true);

  List<Memory> get memories => _memories;
  bool get isLoading => _isLoading;

  Future<void> fetchMemories() async {
    _memories.clear();
    _memories.addAll(await _memoryService.getMemories());
    notifyListeners();
  }
}
