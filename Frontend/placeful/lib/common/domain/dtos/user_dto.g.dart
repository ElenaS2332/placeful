// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  firebaseUid: json['firebaseUid'] as String,
  email: json['email'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  birthDate: DateTime.parse(json['birthDate'] as String),
  friends:
      (json['friends'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
  favoritesMemoriesList:
      json['favoritesMemoriesList'] == null
          ? null
          : FavoriteMemoriesList.fromJson(
            json['favoritesMemoriesList'] as Map<String, dynamic>,
          ),
)..id = json['id'] as String?;

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'firebaseUid': instance.firebaseUid,
  'email': instance.email,
  'fullName': instance.fullName,
  'birthDate': instance.birthDate.toIso8601String(),
  'friends': instance.friends,
  'favoritesMemoriesList': instance.favoritesMemoriesList,
};
