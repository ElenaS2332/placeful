// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  firebaseUid: json['firebaseUid'] as String,
  email: json['email'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  birthDate: DateTime.parse(json['birthDate'] as String),
  favoritesMemoriesList:
      json['favoritesMemoriesList'] == null
          ? null
          : FavoriteMemoriesList.fromJson(
            json['favoritesMemoriesList'] as Map<String, dynamic>,
          ),
)..id = json['id'] as String?;

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'fullName': instance.fullName,
      'birthDate': instance.birthDate.toIso8601String(),
      'favoritesMemoriesList': instance.favoritesMemoriesList?.toJson(),
    };
