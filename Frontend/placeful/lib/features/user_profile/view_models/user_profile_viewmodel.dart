import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserService userService = getIt.get<UserService>();

  UserProfileViewModel();

  bool isLoading = false;
  UserProfile? profile;
  String? error;

  Future<void> loadUserProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      profile = await userService.getUserProfile();
    } catch (e) {
      error = "Failed to load profile: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
