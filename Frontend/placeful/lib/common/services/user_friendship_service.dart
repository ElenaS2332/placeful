import 'package:placeful/common/domain/dtos/request_user_friendship_dto.dart';
import 'package:placeful/common/domain/exceptions/friend_request_already_sent_exception.dart';
import 'package:placeful/common/domain/exceptions/friendship_already_exists_exception.dart';
import 'package:placeful/common/domain/exceptions/http_response_exception.dart';
import 'package:placeful/common/domain/models/user_friendship.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class UserFriendshipService {
  UserFriendshipService([HttpService? client]);

  final HttpService _client = getIt<HttpService>();
  final AuthService authService = getIt<AuthService>();

  Future<List<UserProfile>> getListOfUsers(String searchQuery) async {
    final response =
        await _client.get('user-profile/all-users?fullName=$searchQuery')
            as List<dynamic>;

    final currentUserId = authService.getCurrentUser()!.uid;

    return response
        .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
        .where((user) => user.firebaseUid != currentUserId)
        .toList();
  }

  Future<List<UserFriendship>> getAllFriendships() async {
    final response = await _client.get('user-friendship/active');
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => UserFriendship.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<RequestUserFriendshipDto> sendFriendRequest(String otherUserId) async {
    try {
      final response = await _client.post(
        'user-friendship/request/$otherUserId',
        '',
      );

      return RequestUserFriendshipDto.fromJson(response);
    } on HttpResponseException catch (e) {
      if (e.statusCode == 409) {
        throw FriendRequestAlreadySentException();
      } else if (e.statusCode == 422) {
        throw FriendshipAlreadyExistsException();
      } else {
        rethrow;
      }
    } catch (e) {
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

  Future<int> getCountForFriendRequests() async {
    final response = await _client.get('user-friendship/requests/count');
    return response as int;
  }

  Future<void> acceptFriendRequest(String otherUserId) async {
    await _client.patch('user-friendship/accept/$otherUserId', '');
  }

  Future<void> removeFriend(String otherUserId) async {
    await _client.delete('user-friendship/remove/$otherUserId');
  }

  Future<List<UserProfile>> getMutualFriends(String otherUserId) async {
    final response = await _client.get('user-friendship/mutual/$otherUserId');
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => UserProfile.fromJson(json)).toList();
  }
}
