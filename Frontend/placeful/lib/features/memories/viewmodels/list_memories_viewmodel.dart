import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class ListMemoriesViewModel extends ChangeNotifier {
  final MemoryService _memoryService = getIt.get<MemoryService>();
  final List<Memory> _memories = List<Memory>.empty(growable: true);

  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10;

  List<Memory> get memories => _memories;
  bool get isLoading => _isLoading;

  Future<void> fetchMemories({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    notifyListeners();

    if (!loadMore) {
      _memories.clear();
      _page = 1;
      _hasMore = true;
    }

    final fetched = await _memoryService.getMemories(
      page: _page,
      pageSize: _pageSize,
    );
    if (fetched.length < _pageSize) {
      _hasMore = false;
    }

    _memories.addAll(fetched);
    _page++;
    _isLoading = false;
    notifyListeners();
  }
}
