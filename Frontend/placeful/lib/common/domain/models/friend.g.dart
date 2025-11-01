// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  birthDate:
      json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
  firebaseUid: json['firebaseUid'] as String?,
);

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'birthDate': instance.birthDate?.toIso8601String(),
  'firebaseUid': instance.firebaseUid,
};
