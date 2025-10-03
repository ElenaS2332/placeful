import 'package:json_annotation/json_annotation.dart';
import 'favorite_memories_list.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final DateTime birthDate;
  final List<UserProfile> friends;
  final FavoriteMemoriesList favoritesMemoriesList;

  UserProfile({
    required this.id,
    this.email = '',
    this.fullName = '',
    required this.birthDate,
    this.friends = const [],
    required this.favoritesMemoriesList,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
