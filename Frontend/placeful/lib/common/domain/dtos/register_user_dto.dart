import 'package:json_annotation/json_annotation.dart';

part 'register_user_dto.g.dart';

@JsonSerializable()
class RegisterUserDto {
  final String firebaseUid;
  final String email;
  final String fullName;
  final DateTime birthDate;

  RegisterUserDto({
    required this.firebaseUid,
    required this.email,
    required this.fullName,
    required this.birthDate,
  });

  factory RegisterUserDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserDtoToJson(this);
}
