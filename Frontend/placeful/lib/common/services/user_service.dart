import 'package:placeful/common/domain/dtos/user_dto.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/logger_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class UserService {
  UserService([HttpService? client]);

  final HttpService _client = getIt<HttpService>();
  final LoggerService loggerService = getIt<LoggerService>();
  final AuthService authService = getIt<AuthService>();

  Future<UserProfile?> getUserProfile() async {
    final user = authService.getCurrentUser();

    if (user == null) {
      return null;
    }
    final path = "user-profile/${user.uid}";
    final response = await _client.get(path);
    return UserProfile.fromJson(response);
  }

  Future<void> registerUser({
    required String fullName,
    required String email,
    required DateTime birthDate,
  }) async {
    try {
      await _client.post(
        "user-profile/register",
        UserDto(fullName: fullName, email: email, birthDate: birthDate),
      );
    } on Exception catch (e) {
      loggerService.logError('$e');
    }
  }
}
