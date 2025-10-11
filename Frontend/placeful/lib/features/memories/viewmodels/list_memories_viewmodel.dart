import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/favorite_memories_list.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/favorite_memories_list_service.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class ListMemoriesViewModel extends ChangeNotifier {
  final MemoryService _memoryService = getIt.get<MemoryService>();
  final FavoriteMemoriesListService _favoriteMemoriesListService =
      getIt.get<FavoriteMemoriesListService>();

  final List<Memory> _memories = List<Memory>.empty(growable: true);
  FavoriteMemoriesList favoriteMemoriesList = FavoriteMemoriesList(
    userProfileId: '',
    memories: [],
  );

  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10;

  List<Memory> get memories => _memories;
  bool get isLoading => _isLoading;

  Future<void> fetchMemoriesAndFavoriteList({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    notifyListeners();

    if (!loadMore) {
      _memories.clear();
      _page = 1;
      _hasMore = true;
    }

    favoriteMemoriesList =
        await _favoriteMemoriesListService
            .getFavoriteMemoriesListForCurrentUser();

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

  Future<void> toggleFavorite(String memoryId) async {
    final memoryAlreadyAddedToFavoriteList = favoriteMemoriesList.memories!.any(
      (m) => m.id == memoryId,
    );

    if (memoryAlreadyAddedToFavoriteList) {
      await _favoriteMemoriesListService
          .removeMemoryFromFavoriteMemoriesListForCurrentUser(memoryId);
    } else {
      await _favoriteMemoriesListService
          .addMemoryToFavoriteMemoriesListForCurrentUser(memoryId);
    }
    notifyListeners();
  }
}
