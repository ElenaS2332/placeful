import 'package:json_annotation/json_annotation.dart';
import 'user_profile.dart';
import 'memory.dart';

part 'favorite_memories_list.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteMemoriesList {
  final String id;
  final String userProfileId;
  final String memoryId;
  final UserProfile userProfile;
  final Memory memory;

  FavoriteMemoriesList({
    required this.id,
    required this.userProfileId,
    required this.memoryId,
    required this.userProfile,
    required this.memory,
  });

  factory FavoriteMemoriesList.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMemoriesListFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMemoriesListToJson(this);
}
