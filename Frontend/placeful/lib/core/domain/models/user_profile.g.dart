// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  email: json['email'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  birthDate: DateTime.parse(json['birthDate'] as String),
  friends:
      (json['friends'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  favoritesMemoriesList: FavoriteMemoriesList.fromJson(
    json['favoritesMemoriesList'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'birthDate': instance.birthDate.toIso8601String(),
      'friends': instance.friends.map((e) => e.toJson()).toList(),
      'favoritesMemoriesList': instance.favoritesMemoriesList.toJson(),
    };
