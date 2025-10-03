// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'birthDate': instance.birthDate.toIso8601String(),
};
