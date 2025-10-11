// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserDto _$RegisterUserDtoFromJson(Map<String, dynamic> json) =>
    RegisterUserDto(
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$RegisterUserDtoToJson(RegisterUserDto instance) =>
    <String, dynamic>{
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'fullName': instance.fullName,
      'birthDate': instance.birthDate.toIso8601String(),
    };
