import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/user_dto.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserService userService = getIt.get<UserService>();
  final AuthService authService = getIt.get<AuthService>();

  UserProfileViewModel();

  bool isLoading = false;
  UserDto? profileDto;
  String? error;

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

  Future<void> signOut() async {
    await authService.signOut();
  }
}
