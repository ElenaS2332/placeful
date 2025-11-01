import 'package:flutter/foundation.dart';
import 'package:placeful/common/domain/models/friend.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_service.dart';

class SelectFriendViewModel extends ChangeNotifier {
  final UserService userService = getIt.get<UserService>();

  List<Friend> friends = [];
  bool isLoading = false;
  String? error;

  Future<void> loadFriends() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final profile = await userService.getUserProfile();

      if (profile != null && profile.friends != null) {
        friends =
            profile.friends!
                .map(
                  (f) => Friend(
                    id: f.id ?? '',
                    fullName: f.fullName,
                    email: f.email,
                    firebaseUid: f.firebaseUid,
                  ),
                )
                .toList();
      } else {
        friends = [];
      }
    } catch (e) {
      error = 'Failed to load friends: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
