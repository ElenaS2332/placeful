import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable()
class UpdateUserDto {
  UpdateUserDto({
    required this.firebaseUid,
    this.email = '',
    this.fullName = '',
    this.birthDate,
  });

  final String firebaseUid;
  final String? email;
  final String? fullName;
  final DateTime? birthDate;

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);
}
