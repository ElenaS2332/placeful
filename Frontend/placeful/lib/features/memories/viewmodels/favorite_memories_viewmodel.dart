import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/favorite_memories_list.dart';
import 'package:placeful/common/services/favorite_memories_list_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class FavoriteMemoriesViewModel extends ChangeNotifier {
  final FavoriteMemoriesListService _service =
      getIt.get<FavoriteMemoriesListService>();

  bool _isLoading = false;
  FavoriteMemoriesList? favoriteMemoriesList;

  String? errorMessage;

  void _setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void notifyListenersFromVM() {
    super.notifyListeners();
  }

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      favoriteMemoriesList =
          await _service.getFavoriteMemoriesListForCurrentUser();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
      favoriteMemoriesList;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.clearFavoriteMemoriesListForCurrentUser();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      _setError(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}
