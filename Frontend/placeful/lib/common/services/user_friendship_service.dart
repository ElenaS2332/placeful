import 'package:placeful/common/domain/models/user_friendship.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class UserFriendshipService {
  UserFriendshipService([HttpService? client]);

  final HttpService _client = getIt<HttpService>();
  // final LoggerService loggerService = getIt<LoggerService>();
  final AuthService authService = getIt<AuthService>();

  Future<List<UserProfile>> getListOfUsers(String searchQuery) async {
    final response =
        await _client.get('user-profile?fullName=$searchQuery')
            as List<dynamic>;

    final currentUserId = authService.getCurrentUser()!.uid;

    return response
        .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
        .where((user) => user.id != currentUserId)
        .toList();
  }

  Future<List<UserFriendship>> getAllFriendships() async {
    final response = await _client.get('user-friendship/active');
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => UserFriendship.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<UserFriendship> sendFriendRequest(String otherUserId) async {
    try {
      final response = await _client.post(
        'user-friendship/request/$otherUserId',
        '',
      );
      return UserFriendship.fromJson(response);
    } catch (e) {
      // } on HttpResponseException catch (e) {
      //   if (e.statusCode == 422) {
      //     throw FriendRequestException(
      //         "You are already friends with this person.");
      //   }
      rethrow;
    }
  }

  Future<List<UserFriendship>> getAllFriendRequests() async {
    final response = await _client.get('user-friendship/requests');
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => UserFriendship.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<UserFriendship> acceptFriendRequest(String otherUserId) async {
    final response = await _client.patch(
      'user-friendship/accept/$otherUserId',
      '',
    );
    return UserFriendship.fromJson(response);
  }

  Future<List<UserProfile>> getMutualFriends(String otherUserId) async {
    final response = await _client.get('user-friendship/mutual/$otherUserId');
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => UserProfile.fromJson(json)).toList();
  }
}
