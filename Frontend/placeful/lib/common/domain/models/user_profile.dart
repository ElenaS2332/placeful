import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/user_dto.dart';
import 'favorite_memories_list.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile {
  UserProfile({
    required this.firebaseUid,
    this.email = '',
    this.fullName = '',
    required this.birthDate,
    this.friends,
    this.favoritesMemoriesList,
  });

  late final String? id;
  late final String firebaseUid;
  late final String email;
  late final String fullName;
  late final DateTime birthDate;
  late final List<UserProfile>? friends;
  late final FavoriteMemoriesList? favoritesMemoriesList;

  UserProfile.fromDto(UserDto dto)
    : firebaseUid = dto.firebaseUid,
      email = dto.email,
      fullName = dto.fullName,
      friends = dto.friends,
      birthDate = dto.birthDate;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
