import 'package:placeful/common/domain/dtos/register_user_dto.dart';
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
    final path = "user-profile";
    final response = await _client.get(path);

    final dto = UserDto.fromJson(response as Map<String, dynamic>);
    return UserProfile.fromDto(dto);
  }

  Future<void> registerUser({
    required String firebaseUid,
    required String fullName,
    required String email,
    required DateTime birthDate,
  }) async {
    try {
      await _client.post(
        "user-profile/register",
        RegisterUserDto(
          firebaseUid: firebaseUid,
          fullName: fullName,
          email: email,
          birthDate: birthDate,
        ),
      );
    } on Exception catch (e) {
      loggerService.logError('$e');
    }
  }
}
