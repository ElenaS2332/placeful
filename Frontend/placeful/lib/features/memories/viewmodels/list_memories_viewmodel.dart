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
  String? errorMessage;

  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10;
  String _currentSearchQuery = '';

  List<Memory> get memories => _memories;
  bool get isLoading => _isLoading;
  bool get isSearching => _currentSearchQuery.isNotEmpty;

  void _setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchMemoriesAndFavoriteList({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (!loadMore) {
        _memories.clear();
        _page = 1;
        _hasMore = true;
      }

      favoriteMemoriesList =
          await _favoriteMemoriesListService
              .getFavoriteMemoriesListForCurrentUser();

      List<Memory> fetched;

      if (_currentSearchQuery.isNotEmpty) {
        fetched = await _memoryService.searchMemories(
          _currentSearchQuery,
          page: _page,
          pageSize: _pageSize,
        );
      } else {
        fetched = await _memoryService.getMemories(
          page: _page,
          pageSize: _pageSize,
        );
      }

      if (fetched.length < _pageSize) {
        _hasMore = false;
      }

      _memories.addAll(fetched);
      _page++;
    } catch (e) {
      _setError("Failed to load memories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String memoryId) async {
    final memoryAlreadyAdded = favoriteMemoriesList.memories!.any(
      (m) => m.id == memoryId,
    );

    try {
      if (memoryAlreadyAdded) {
        favoriteMemoriesList.memories!.removeWhere((m) => m.id == memoryId);
        notifyListeners();

        await _favoriteMemoriesListService
            .removeMemoryFromFavoriteMemoriesListForCurrentUser(memoryId);
      } else {
        favoriteMemoriesList.memories!.add(
          memories.firstWhere((m) => m.id == memoryId),
        );
        notifyListeners();

        await _favoriteMemoriesListService
            .addMemoryToFavoriteMemoriesListForCurrentUser(memoryId);
      }
    } catch (e) {
      if (memoryAlreadyAdded) {
        favoriteMemoriesList.memories!.add(
          memories.firstWhere((m) => m.id == memoryId),
        );
      } else {
        favoriteMemoriesList.memories!.removeWhere((m) => m.id == memoryId);
      }
      notifyListeners();
      _setError("Something went wrong while toggling favorite");
    }
  }

  int _activeSearchId = 0;

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery == _currentSearchQuery) return;

    _currentSearchQuery = trimmedQuery;
    _memories.clear();
    _page = 1;
    _hasMore = true;
    notifyListeners();

    final currentSearchId = ++_activeSearchId;

    if (_currentSearchQuery.isEmpty) {
      await fetchMemoriesAndFavoriteList();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final results = await _memoryService.searchMemories(
        _currentSearchQuery,
        page: _page,
        pageSize: _pageSize,
      );

      if (currentSearchId != _activeSearchId) return;

      _memories
        ..clear()
        ..addAll(results);
      _page++;
      _hasMore = results.length >= _pageSize;
    } catch (e) {
      if (currentSearchId == _activeSearchId) {
        _setError("Search failed: $e");
      }
    } finally {
      if (currentSearchId == _activeSearchId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> clearSearch() async {
    if (_currentSearchQuery.isEmpty) return;

    _currentSearchQuery = '';
    _memories.clear();
    _page = 1;
    _hasMore = true;
    notifyListeners();

    await fetchMemoriesAndFavoriteList();
  }
}
