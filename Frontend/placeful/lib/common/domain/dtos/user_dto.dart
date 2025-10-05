import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/favorite_memories_list.dart';
import 'package:placeful/common/domain/models/user_profile.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  UserDto({
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

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
