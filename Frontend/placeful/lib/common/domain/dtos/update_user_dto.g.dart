// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserDto _$UpdateUserDtoFromJson(Map<String, dynamic> json) =>
    UpdateUserDto(
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      birthDate:
          json['birthDate'] == null
              ? null
              : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$UpdateUserDtoToJson(UpdateUserDto instance) =>
    <String, dynamic>{
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'fullName': instance.fullName,
      'birthDate': instance.birthDate?.toIso8601String(),
    };
