import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto extends Equatable {
  final String firebaseUid;
  final String fullName;
  final String email;
  final DateTime birthDate;

  const UserDto({
    required this.firebaseUid,
    required this.fullName,
    required this.email,
    required this.birthDate,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @override
  List<Object?> get props => [fullName, birthDate];
}
