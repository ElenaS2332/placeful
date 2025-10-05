import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:placeful/common/domain/models/user_friendship.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/services/logger_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_friendship_service.dart';

class AddFriendViewModel extends ChangeNotifier {
  final _userFriendshipService = getIt<UserFriendshipService>();
  final _loggerService = getIt<LoggerService>();

  final List<UserProfile> _searchResults = [];
  final List<UserFriendship> _friendRequests = [];

  List<UserProfile> get searchResults => List.unmodifiable(_searchResults);
  List<UserFriendship> get friendRequests => List.unmodifiable(_friendRequests);

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool _isLoadingRequests = true;
  bool get isLoadingRequests => _isLoadingRequests;

  Timer? _debounce;

  AddFriendViewModel() {
    loadFriendRequests();
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchUsers(query);
    });
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final users = await _userFriendshipService.getListOfUsers(query);
      _searchResults
        ..clear()
        ..addAll(users);
    } catch (e) {
      _loggerService.logError('Error while searching users: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> addFriend(String userId) async {
    try {
      await _userFriendshipService.sendFriendRequest(userId);
      _searchResults.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('You already are friends with this person');
    }
  }

  Future<void> loadFriendRequests() async {
    try {
      final requests = await _userFriendshipService.getAllFriendRequests();
      _friendRequests
        ..clear()
        ..addAll(requests);
    } catch (e) {
      _loggerService.logError('Error loading friend requests: $e');
    } finally {
      _isLoadingRequests = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequest(String userId) async {
    try {
      await _userFriendshipService.acceptFriendRequest(userId);
      _friendRequests.removeWhere((r) => r.friendshipInitiatorId == userId);
      notifyListeners();
    } catch (e) {
      _loggerService.logError('Failed to accept friend request: $e');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
