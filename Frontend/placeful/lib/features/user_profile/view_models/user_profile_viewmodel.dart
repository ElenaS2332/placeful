import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/user_dto.dart';
import 'package:placeful/common/domain/models/user_friendship.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/logger_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_friendship_service.dart';
import 'package:placeful/common/services/user_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserService userService = getIt.get<UserService>();
  final UserFriendshipService friendshipService =
      getIt.get<UserFriendshipService>();
  final AuthService authService = getIt.get<AuthService>();
  final LoggerService loggerService = getIt.get<LoggerService>();

  UserDto? profileDto;
  String? error;
  bool isLoading = false;

  final List<UserFriendship> _friendRequests = [];
  List<UserFriendship> get friendRequests => List.unmodifiable(_friendRequests);
  bool isLoadingRequests = false;

  int friendRequestsCount = 0;

  Future<void> loadUserProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final profile = await userService.getUserProfile();
      if (profile != null) {
        profileDto = UserDto(
          firebaseUid: profile.firebaseUid,
          fullName: profile.fullName,
          email: profile.email,
          birthDate: profile.birthDate,
          friends: profile.friends,
        );
      } else {
        error = "No profile found";
      }
    } catch (e) {
      error = "Failed to load profile: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFriendRequests() async {
    isLoadingRequests = true;
    notifyListeners();

    try {
      _friendRequests.clear();
      final requests = await friendshipService.getAllFriendRequests();
      _friendRequests.addAll(requests);
      friendRequestsCount = await friendshipService.getCountForFriendRequests();
    } catch (e) {
      loggerService.logError('Error loading friend requests: $e');
    } finally {
      isLoadingRequests = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequest(String userId) async {
    try {
      await friendshipService.acceptFriendRequest(userId);
      _friendRequests.removeWhere((r) => r.friendshipInitiatorId == userId);
      friendRequestsCount = _friendRequests.length;
      notifyListeners();
    } catch (e) {
      loggerService.logError('Failed to accept friend request: $e');
    }
  }

  Future<void> removeFriend(String otherUserId) async {
    try {
      await friendshipService.removeFriend(otherUserId);
      profileDto?.friends?.removeWhere((f) => f.firebaseUid == otherUserId);
      notifyListeners();
    } catch (e) {
      error = "Failed to remove friend: $e";
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      await userService.deleteUserAccount();
      await authService.signOut();
    } catch (e) {
      error = "Failed to delete account: $e";
      notifyListeners();
    }
  }
}
